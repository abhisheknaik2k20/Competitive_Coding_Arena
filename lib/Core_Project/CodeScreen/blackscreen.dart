// ignore_for_file: unused_field
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:competitivecodingarena/API_KEYS/api.dart';
import 'package:competitivecodingarena/Core_Project/CodeScreen/submission_screen.dart';
import 'package:competitivecodingarena/Core_Project/CodeScreen/invite_friends.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Core_Project/CodeScreen/dragcontain.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/examples/exampleprobs.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:segmented_button_slide/segmented_button_slide.dart';

class BlackScreen extends StatefulWidget {
  final String? teamid;
  final Problem problem;
  final Size size;
  final bool isOnline;
  const BlackScreen(
      {required this.teamid,
      required this.isOnline,
      required this.problem,
      required this.size,
      super.key});
  @override
  State<BlackScreen> createState() => _BlackScreenState();
}

const List<Map<String, dynamic>> _availableContainersData = [
  {'name': 'Description', 'icon': Icons.description, 'color': Colors.red},
  {'name': 'Code', 'icon': Icons.code, 'color': Colors.blue},
  {'name': 'Solutions', 'icon': Icons.lightbulb, 'color': Colors.yellow},
  {'name': 'TestCases', 'icon': Icons.check_box, 'color': Colors.green},
  {'name': 'Console', 'icon': Icons.check_box, 'color': Colors.indigo}
];

const List<Map<String, dynamic>> _onlineContainersData = [
  {'name': 'Description', 'icon': Icons.description, 'color': Colors.red},
  {'name': 'OnlineCode', 'icon': Icons.code, 'color': Colors.blue},
  {'name': 'Solutions', 'icon': Icons.lightbulb, 'color': Colors.yellow},
  {'name': 'TestCases', 'icon': Icons.check_box, 'color': Colors.green},
  {'name': 'Console', 'icon': Icons.check_box, 'color': Colors.indigo}
];

class _BlackScreenState extends State<BlackScreen> {
  final List<Widget> _containers = [];
  final List<Map<String, dynamic>> _availableContainers =
      List.from(_availableContainersData);
  final List<Map<String, dynamic>> _onlineContainers =
      List.from(_onlineContainersData);
  final Set<int> _remoteUids = {};
  final Map<int, bool> _speakingUsers = {};
  final Map<int, String> _userNames = {};
  late TextEditingController _textController;
  late ScrollController _scrollController;
  late AudioPlayer _audioPlayer;
  late String _authUser;
  bool _localUserJoined = false;
  RtcEngine? _engine;
  List<QueryDocumentSnapshot> _chatDocs = [];
  bool _isLoading = true;
  bool _isAgoraInitialized = true;
  bool _isAudioOn = true;
  FirebaseFirestore? _firestore;
  Stream<QuerySnapshot>? _chatsStream;
  int _selectedTab = 0;
  static const double _chatBubbleBorderRadius = 10.0;
  static const EdgeInsets _chatBubblePadding =
      EdgeInsets.symmetric(vertical: 8, horizontal: 12);

  @override
  void initState() {
    super.initState();
    _initializeFields();
    if (widget.isOnline) _initAgora();
    _initializeChatsStream();
    _initializeAudioPlayer();
  }

  void _initializeFields() {
    _textController = TextEditingController();
    _scrollController = ScrollController();
    _audioPlayer = AudioPlayer();
    _authUser = FirebaseAuth.instance.currentUser?.displayName ?? 'Guest';
    _firestore = FirebaseFirestore.instance;
    _userNames[0] = "You";
  }

  Future<void> _initializeAudioPlayer() async {
    await _audioPlayer.setSource(AssetSource('sounds/mp.mp3'));
    await _audioPlayer.setReleaseMode(ReleaseMode.release);
  }

  void _initializeChatsStream() {
    if (widget.teamid == null) return;
    _chatsStream = _firestore
        ?.collection('code')
        .doc(widget.teamid)
        .collection('chats')
        .orderBy('timestamp', descending: false)
        .snapshots();
    _chatsStream?.listen((snapshot) {
      if (_chatDocs.length < snapshot.docs.length && _chatDocs.isNotEmpty) {
        _playMessageSound();
      }
      if (mounted) {
        setState(() {
          _chatDocs = snapshot.docs;
          _isLoading = false;
        });
      }
    });
  }

  void _playMessageSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.resume();
    } catch (e) {
      // Silently handle audio errors
    }
  }

  Future<void> _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || widget.teamid == null) return;
    final message = {
      "sender": _authUser,
      "message": text,
      "timestamp": FieldValue.serverTimestamp()
    };
    _textController.clear();
    try {
      await _firestore
          ?.collection('code')
          .doc(widget.teamid)
          .collection('chats')
          .add(message);
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut);
        }
      });
    } catch (e) {
      // Handle errors silently
    }
  }

  Future<void> _initAgora() async {
    try {
      await [Permission.microphone].request();
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(RtcEngineContext(
          appId: ApiKeys().appId,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting));
      _setupAgoraEventHandlers();
      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await _engine!.enableAudioVolumeIndication(
          interval: 200, smooth: 3, reportVad: true);
      await _engine!.joinChannel(
          token: ApiKeys().token,
          channelId: ApiKeys().channel,
          uid: 0,
          options: const ChannelMediaOptions());
      if (mounted) setState(() => _isAgoraInitialized = true);
    } catch (e) {
      if (mounted) setState(() => _isAgoraInitialized = false);
    }
  }

  void _setupAgoraEventHandlers() {
    _engine?.registerEventHandler(RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          if (!mounted) return;
          setState(() {
            _localUserJoined = true;
            _userNames[0] = "You";
          });
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          if (!mounted) return;
          setState(() {
            _remoteUids.add(remoteUid);
            _userNames[remoteUid] = "User $remoteUid";
            _speakingUsers[remoteUid] = false;
          });
        },
        onUserOffline: (connection, remoteUid, reason) {
          if (!mounted) return;
          setState(() {
            _remoteUids.remove(remoteUid);
            _userNames.remove(remoteUid);
            _speakingUsers.remove(remoteUid);
          });
        },
        onAudioVolumeIndication:
            (connection, speakers, speakerNumber, totalVolume) {
          if (!mounted) return;
          bool needsUpdate = false;
          final Map<int, bool> updates = {};
          for (var speaker in speakers) {
            final uid = speaker.uid!;
            final isSpeaking = speaker.volume! > 5;
            if (_speakingUsers[uid] != isSpeaking) {
              updates[uid] = isSpeaking;
              needsUpdate = true;
            }
          }
          if (needsUpdate) {
            setState(() => updates
                .forEach((uid, speaking) => _speakingUsers[uid] = speaking));
          }
        },
        onTokenPrivilegeWillExpire: (connection, token) {}));
  }

  @override
  void dispose() {
    _closeAgoraConnection();
    _disposeControllers();
    super.dispose();
  }

  Future<void> _closeAgoraConnection() async {
    if (_engine != null) {
      try {
        await _engine!.leaveChannel();
        await _engine!.release();
      } catch (e) {
        // Handle errors silently
      }
    }
  }

  void _disposeControllers() {
    _textController.dispose();
    _scrollController.dispose();
    _audioPlayer.dispose();
  }

  void _toggleAudio() {
    if (_engine != null) {
      setState(() => _isAudioOn = !_isAudioOn);
      _engine!.enableLocalAudio(_isAudioOn);
    }
  }

  Widget _buildUserList() => Container(
      width: widget.size.width * 0.2,
      color: Colors.grey[900],
      child: Column(children: [
        const SizedBox(height: 10),
        SizedBox(
            width: 250,
            height: 60,
            child: SegmentedButtonSlide(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                entries: const [
                  SegmentedButtonSlideEntry(
                      icon: Icons.voice_chat, label: "Voice-Chat"),
                  SegmentedButtonSlideEntry(
                      icon: Icons.text_fields, label: "Text-Chat")
                ],
                selectedEntry: _selectedTab,
                onChange: (selected) => setState(() => _selectedTab = selected),
                colors: SegmentedButtonSlideColors(
                    barColor: Colors.blue.shade500,
                    backgroundSelectedColor: Colors.blue.shade300))),
        Expanded(child: _selectedTab == 1 ? _buildChatUI() : _buildVoiceUI())
      ]));

  Widget _buildVoiceUI() => ListView(children: [
        _buildUserTile(0, "You"),
        ..._remoteUids
            .map((uid) => _buildUserTile(uid, _userNames[uid] ?? "User $uid"))
      ]);

  Widget _buildChatUI() => _isLoading
      ? const Center(child: CircularProgressIndicator())
      : _buildUserChats();

  Widget _buildUserTile(int uid, String name) {
    final bool isSpeaking = _speakingUsers[uid] ?? false;
    final Color tileColor =
        isSpeaking ? Colors.green.shade700 : Colors.grey.shade800;
    final Color avatarColor =
        isSpeaking ? Colors.green.shade300 : Colors.grey.shade600;
    final Color borderColor = isSpeaking ? Colors.greenAccent : Colors.white30;
    final Color textColor = isSpeaking ? Colors.white : Colors.grey.shade300;
    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: isSpeaking
                      ? Colors.green.withOpacity(0.3)
                      : Colors.transparent,
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(colors: [
              tileColor,
              isSpeaking ? Colors.green.shade500 : Colors.grey.shade700
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 2)),
                child: CircleAvatar(
                    backgroundColor: avatarColor,
                    child: Text(name.isNotEmpty ? name[0].toUpperCase() : "?",
                        style: TextStyle(
                            color: textColor, fontWeight: FontWeight.bold)))),
            title: Text(name,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        isSpeaking ? FontWeight.bold : FontWeight.normal,
                    fontSize: 16)),
            trailing: Icon(isSpeaking ? Icons.mic : Icons.mic_off,
                color: isSpeaking ? Colors.greenAccent : Colors.white30)));
  }

  Widget _buildUserChats() => SizedBox(
      height: widget.size.height * 0.899,
      child: Column(children: [
        Expanded(
            child: _chatDocs.isEmpty
                ? _buildStartChattingMessage()
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _chatDocs.length,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    itemBuilder: (context, index) {
                      final chat =
                          _chatDocs[index].data() as Map<String, dynamic>;
                      final bool isCurrentUser = chat["sender"] == _authUser;
                      return _buildChatBubble(chat, isCurrentUser);
                    })),
        _buildChatInput()
      ]));

  Widget _buildChatInput() => Container(
      padding: const EdgeInsets.all(5),
      height: widget.size.height * 0.1,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue[300]!),
          borderRadius: BorderRadius.circular(5)),
      child: Row(children: [
        Expanded(
            child: RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (RawKeyEvent event) {
                  if (event is RawKeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.enter &&
                      !event.isShiftPressed) {
                    _sendMessage();
                  }
                },
                child: TextField(
                    controller: _textController,
                    cursorColor: Colors.blue,
                    style: TextStyle(color: Colors.grey[900]),
                    decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[300],
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue[300]!),
                            borderRadius: BorderRadius.circular(5)))))),
        const SizedBox(width: 10),
        IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
            color: Colors.white,
            iconSize: 24,
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all<Color>(Colors.blue[400]!),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        side: BorderSide(width: 2, color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(5))),
                padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                minimumSize: WidgetStateProperty.all<Size>(const Size(60, 60)),
                alignment: Alignment.center))
      ]));
  Widget _buildChatBubble(Map<String, dynamic> chat, bool isCurrentUser) {
    final String message = chat["message"] ?? "";
    final String sender = chat["sender"] ?? "Unknown";

    return Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            constraints: BoxConstraints(maxWidth: widget.size.width * 0.75),
            decoration: BoxDecoration(
                color: isCurrentUser ? Colors.blue[100] : Colors.grey[300],
                borderRadius: BorderRadius.circular(_chatBubbleBorderRadius),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 2))
                ]),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                    borderRadius:
                        BorderRadius.circular(_chatBubbleBorderRadius),
                    onTap: () {}, // Empty callback to show ripple
                    child: Padding(
                        padding: _chatBubblePadding,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(message,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black87)),
                              const SizedBox(height: 4),
                              Text(sender,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[800],
                                      fontStyle: FontStyle.italic))
                            ]))))));
  }

  @override
  Widget build(BuildContext context) {
    final bool showUserList = widget.isOnline && _isAgoraInitialized;
    final bool showFloatingActionButton = showUserList && _selectedTab == 0;
    return Scaffold(
        body: Row(children: [
          SizedBox(
              width: showUserList ? widget.size.width * 0.8 : widget.size.width,
              child: Stack(children: [
                ..._containers,
                Positioned(
                    left: 0,
                    right: 0,
                    child: SizedBox(
                        height: 50,
                        child: Container(
                            width: 200,
                            decoration:
                                BoxDecoration(color: Colors.grey.shade800),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: _buildContainerButtons()))))
              ])),
          if (showUserList) _buildUserList()
        ]),
        floatingActionButton:
            showFloatingActionButton ? _buildFloatingActionButtons() : null);
  }

  List<Widget> _buildContainerButtons() {
    final containerList =
        widget.isOnline ? _onlineContainers : _availableContainers;
    return containerList
        .map((container) => TextButton.icon(
            onPressed: () => _addContainer(widget.problem, container['name'],
                container['icon'], container['color']),
            icon: Icon(container['icon'], color: container['color']),
            label: Text(container['name'],
                style: const TextStyle(color: Colors.white))))
        .toList();
  }

  Widget _buildFloatingActionButtons() =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        FloatingActionButton(
            onPressed: _toggleAudio,
            backgroundColor: Colors.blue[400],
            child: Icon(_isAudioOn ? Icons.mic : Icons.mic_off)),
        const SizedBox(width: 10),
        InviteFriendsButton(
            title:
                "${(FirebaseAuth.instance.currentUser?.displayName?.split(' ').first ?? 'User')}'s Inviting",
            body: 'The Team code is ${widget.teamid}')
      ]);

  void _addContainer(
      Problem problem, String name, IconData icon, MaterialColor color) {
    if (name == "Solutions") {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Submissions(problem: problem)));
      return;
    }
    setState(() {
      final containerKey = Key('container_$name');
      _containers.add(DraggableResizableContainer(
          teamid: widget.isOnline ? widget.teamid : null,
          problem: problem,
          color: color,
          icon: icon,
          key: containerKey,
          initialPosition: Offset(20.0 * (_containers.length + 1), 70.0),
          initialSize: Size(widget.size.width * 0.3, widget.size.height * 0.3),
          minSize: const Size(100, 100),
          maxSize: Size(widget.size.width * 0.9, widget.size.height * 0.9),
          onRemove: _removeContainer,
          label: name,
          returnToButtonBar: _returnToButtonBar,
          bringToFront: _bringContainerToFront));
      if (widget.isOnline) {
        _onlineContainers.removeWhere((container) => container['name'] == name);
      } else {
        _availableContainers
            .removeWhere((container) => container['name'] == name);
      }
    });
  }

  void _removeContainer(Key key) => setState(
      () => _containers.removeWhere((container) => container.key == key));

  void _returnToButtonBar(String name, IconData icon, MaterialColor color) =>
      setState(() {
        _containers.removeWhere(
            (container) => container.key == Key('container_$name'));
        final containerData = {'name': name, 'icon': icon, 'color': color};
        if (!_availableContainers
            .any((container) => container['name'] == name)) {
          _availableContainers.add(containerData);
        }
        if (!_onlineContainers.any((container) => container['name'] == name)) {
          _onlineContainers.add(containerData);
        }
      });

  void _bringContainerToFront(Key key) => setState(() {
        final index =
            _containers.indexWhere((container) => container.key == key);
        if (index != -1) {
          final container = _containers.removeAt(index);
          _containers.add(container);
        }
      });
  Widget _buildStartChattingMessage() => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey[400]),
        const SizedBox(height: 16),
        Text("Start chatting",
            style: TextStyle(
                fontSize: 20,
                color: Colors.grey[400],
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text("Send a message to begin the conversation",
            style: TextStyle(fontSize: 14, color: Colors.grey[600]))
      ]));
}
