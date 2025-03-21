import 'package:competitivecodingarena/Messaging/messages_logic.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InviteFriendsButton extends StatefulWidget {
  final String title;
  final String body;
  const InviteFriendsButton(
      {required this.title, required this.body, super.key});

  @override
  State<InviteFriendsButton> createState() => _InviteFriendsButtonState();
}

class _InviteFriendsButtonState extends State<InviteFriendsButton> {
  final Map<String, bool> _loadingStates = {};
  Future<void> _inviteNotification(String token, String userId) async {
    setState(() {
      _loadingStates[userId] = true;
    });
    try {
      await PushNotification.sendNotification(
          token: token, title: widget.title, body: widget.body);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Invitation sent successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2)));
      }
    } catch (error) {
      print(error.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to send invitation: ${error.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3)));
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingStates[userId] = false;
        });
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  void _showUsersDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: _UsersListDialog(
                  fetchUsers: fetchUsers,
                  onInviteUser: _inviteNotification,
                  loadingStates: _loadingStates));
        });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () => _showUsersDialog(context),
        backgroundColor: Colors.blue[700],
        child: Icon(Icons.group, semanticLabel: 'Invite Friends'));
  }
}

class _UsersListDialog extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> Function() fetchUsers;
  final Future<void> Function(String, String) onInviteUser;
  final Map<String, bool> loadingStates;

  const _UsersListDialog({
    required this.fetchUsers,
    required this.onInviteUser,
    required this.loadingStates,
  });

  @override
  State<_UsersListDialog> createState() => _UsersListDialogState();
}

class _UsersListDialogState extends State<_UsersListDialog> {
  late Future<List<Map<String, dynamic>>> _usersFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _usersFuture = widget.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
            width: MediaQuery.sizeOf(context).width * 0.4,
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8),
            decoration: BoxDecoration(
              color: Color(0xFF121212),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _buildHeader(),
              _buildSearchBar(),
              Divider(height: 1, color: Colors.grey[800]),
              Flexible(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _usersFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return _buildLoadingState();
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return _buildEmptyState();
                        }
                        final users = snapshot.data!.where((user) {
                          final name = (user['name'] ?? '').toLowerCase();
                          final email = (user['email'] ?? '').toLowerCase();
                          final query = _searchQuery.toLowerCase();
                          return name.contains(query) || email.contains(query);
                        }).toList();
                        if (users.isEmpty) {
                          return _buildNoSearchResultsState();
                        }
                        return _buildUsersList(users);
                      })),
              _buildFooter()
            ])));
  }

  Widget _buildHeader() {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Row(children: [
          Icon(Icons.people_alt_rounded, color: Colors.blue[300], size: 28),
          SizedBox(width: 12),
          Text("Invite Friends",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Spacer(),
          IconButton(
              icon: Icon(Icons.close, color: Colors.grey[400]),
              onPressed: () => Navigator.pop(context))
        ]));
  }

  Widget _buildSearchBar() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
                hintText: 'Search users...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                contentPadding: EdgeInsets.symmetric(vertical: 12))));
  }

  Widget _buildLoadingState() {
    return Container(
        padding: EdgeInsets.all(40),
        child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[300]!)),
          SizedBox(height: 16),
          Text("Loading users...",
              style: TextStyle(fontSize: 16, color: Colors.grey[400]))
        ])));
  }

  Widget _buildEmptyState() {
    return Container(
        padding: EdgeInsets.all(40),
        child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.person_off, size: 48, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text("No users found",
              style: TextStyle(fontSize: 18, color: Colors.grey[400]))
        ])));
  }

  Widget _buildNoSearchResultsState() {
    return Container(
        padding: EdgeInsets.all(40),
        child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text("No matches found",
              style: TextStyle(fontSize: 18, color: Colors.grey[400])),
          SizedBox(height: 8),
          Text("Try a different search term",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]))
        ])));
  }

  Widget _buildUsersList(List<Map<String, dynamic>> users) {
    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shrinkWrap: true,
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final name = user['name'] ?? 'Unknown';
          final email = user['email'] ?? '';
          final userId = user['id'] ?? '$index';
          final token = user['token'] ?? '';
          final isLoading = widget.loadingStates[userId] ?? false;
          final initials = name.isNotEmpty
              ? name
                  .split(' ')
                  .map((e) => e.isNotEmpty ? e[0] : '')
                  .join()
                  .toUpperCase()
              : '?';
          return Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16)),
              child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: isLoading
                          ? null
                          : () => widget.onInviteUser(token, userId),
                      child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(children: [
                            _buildUserAvatar(user, initials),
                            SizedBox(width: 16),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text(name,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  SizedBox(height: 4),
                                  Text(email,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[400],
                                      ))
                                ])),
                            _buildInviteButton(isLoading),
                          ])))));
        });
  }

  Widget _buildUserAvatar(Map<String, dynamic> user, String initials) {
    return user['profilePic'] != null && user['profilePic'].isNotEmpty
        ? Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue[700]!, width: 2),
                image: DecorationImage(
                  image: NetworkImage(user['profilePic']),
                  fit: BoxFit.cover,
                )))
        : Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue[700],
            ),
            child: Center(
                child: Text(initials,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18))));
  }

  Widget _buildInviteButton(bool isLoading) {
    return SizedBox(
        width: 84,
        height: 36,
        child: ElevatedButton(
            onPressed: isLoading ? null : null,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white)))
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.send, size: 16),
                    SizedBox(width: 4),
                    Text("Invite", style: TextStyle(fontSize: 14))
                  ])));
  }

  Widget _buildFooter() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(color: Color(0xFF1E1E1E), boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: Offset(0, -3))
        ]),
        child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: Text("Done",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))));
  }
}
