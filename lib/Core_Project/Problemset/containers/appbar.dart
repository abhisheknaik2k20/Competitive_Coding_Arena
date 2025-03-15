import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:competitivecodingarena/Core_Project/Premium/buy_membership.dart';
import 'package:competitivecodingarena/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Auth_Profile_Logic/login_signup.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/styles/styles.dart';
import 'package:competitivecodingarena/Auth_Profile_Logic/Profile/ProfilePage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeAppBar extends StatefulWidget {
  final Function(String) setItem;
  const HomeAppBar({required this.setItem, super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBar();
}

class _HomeAppBar extends State<HomeAppBar> {
  String selectedButton = "Problems";
  List<Map<String, String>> Images = [
    {"imageurl": "assets/images/userpng.png", "name": "Profile"},
    {"imageurl": "assets/images/list.png", "name": "Lists"},
    {"imageurl": "assets/images/progress.png", "name": "Progress"},
    {"imageurl": "assets/images/trophy.png", "name": "Contest"},
    {"imageurl": "assets/images/settings.png", "name": "Settings"},
    {"imageurl": "assets/images/help.png", "name": "Help"},
  ];
  bool isPremiumMember = false;

  Future<void> checkPremiumStatus() async {
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          isPremiumMember = docSnapshot.data()?['isPremium'] ?? false;
        });
      }
    }
  }

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPremiumStatus();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SliverAppBar(
      pinned: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          height: 2.0,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      toolbarHeight: 50,
      backgroundColor: isDarkMode
          ? const Color.fromARGB(255, 40, 40, 40)
          : Colors.grey.shade100,
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 200),
            Image.asset(
              "assets/images/logo.png",
              width: 40,
            ),
            const SizedBox(
              width: 30,
            ),
            for (String buttonText in [
              "Problems",
              "Contest",
              "Road-Map",
              "Community",
              "Stack-Overflow",
            ])
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedButton = buttonText;
                      widget.setItem(buttonText);
                    });
                  },
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Text(buttonText,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: buttonText == selectedButton
                                ? Colors.blue
                                : isDarkMode
                                    ? Colors.white
                                    : Colors.grey.shade500,
                          )),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 50,
                        height: 8,
                        color: buttonText == selectedButton
                            ? Colors.blue
                            : Colors.transparent,
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        _buildAccountDropdown(context),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none,
            color: Colors.blue,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.bolt,
            color: Colors.blue,
          ),
        ),
        if (!isPremiumMember)
          Padding(
            padding: const EdgeInsets.all(5),
            child: ElevatedButton(
              style: buttonStyle2(),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const BuyMembership()));
              },
              child: const Text(
                "Premium",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.all(5),
            child: Icon(Icons.star, color: Colors.yellow),
          ),
        const SizedBox(
          width: 200,
        )
      ],
    );
  }

  Widget _buildAccountDropdown(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return PopupMenuButton<String>(
      tooltip: "Profile Menu",
      offset: const Offset(0, 56),
      icon: Icon(Icons.account_circle, color: Colors.grey[700]),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          enabled: false,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: user?.photoURL != null
                  ? CachedNetworkImageProvider(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            title: Text(user?.displayName ?? 'User',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        PopupMenuItem<String>(
          enabled: false,
          child: SizedBox(
            height: 180,
            width: 300,
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                for (Map<String, String> image in Images)
                  _buildGridItem(image['imageurl']!, image['name']!)
              ],
            ),
          ),
        ),
        PopupMenuItem<String>(child: ThemeToggleButton()),
        PopupMenuItem<String>(
          value: 'sign_out',
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 10, right: 10),
            leading: Icon(Icons.exit_to_app, color: Colors.grey[700]),
            title: const Text('Sign Out'),
          ),
        ),
      ],
      onSelected: (String value) async {
        if (value == 'sign_out') {
          logoutLogic(context);
        }
      },
    );
  }

  Widget _buildGridItem(String image, String label) {
    return InkWell(
      onTap: () {
        if (label == "Profile") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LeetCodeProfile(),
            ),
          );
        }
        if (label == "Contest") {
          widget.setItem("Contest");
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: 40,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final isDarkMode = theme.brightness == Brightness.dark;

    return ListTile(
      onTap: () async {
        // Use async/await since toggleTheme is asynchronous
        await ref.read(themeProvider.notifier).toggleTheme();
      },
      contentPadding: const EdgeInsets.only(left: 10, right: 10),
      leading: isDarkMode
          ? const Icon(Icons.light_mode, color: Colors.yellow)
          : const Icon(Icons.dark_mode, color: Colors.blue),
      title: Text(isDarkMode ? 'Light-Mode' : 'Dark-Mode'),
    );
  }
}
