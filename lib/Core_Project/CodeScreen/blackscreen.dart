import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:competitivecodingarena/API_KEYS/api.dart';
import 'package:competitivecodingarena/Core_Project/CodeScreen/Submissions/submission.dart';
import 'package:competitivecodingarena/Core_Project/CodeScreen/invite_friends.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Core_Project/CodeScreen/dragcontain.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/examples/exampleprobs.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
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

List<Map<String, dynamic>> chats = [];

class _BlackScreenState extends State<BlackScreen> {
  List<Widget> containers = [];
  List<Map<String, dynamic>> availableContainers = [
    {'name': 'Description', 'icon': Icons.description, 'color': Colors.red},
    {'name': 'Code', 'icon': Icons.code, 'color': Colors.blue},
    {'name': 'Solutions', 'icon': Icons.lightbulb, 'color': Colors.yellow},
    {'name': 'TestCases', 'icon': Icons.check_box, 'color': Colors.green},
    {'name': 'Console', 'icon': Icons.check_box, 'color': Colors.indigo},
  ];

  List<Map<String, dynamic>> onlineContainers = [
    {'name': 'Description', 'icon': Icons.description, 'color': Colors.red},
    {'name': 'OnlineCode', 'icon': Icons.code, 'color': Colors.blue},
    {'name': 'Solutions', 'icon': Icons.lightbulb, 'color': Colors.yellow},
    {'name': 'TestCases', 'icon': Icons.check_box, 'color': Colors.green},
    {'name': 'Console', 'icon': Icons.check_box, 'color': Colors.indigo},
  ];
  Set<int>? _remoteUids;
  TextEditingController? tc;
  ScrollController? sc;
  AudioPlayer? _audioPlayer;
  String? _authUser;
  // ignore: unused_field
  bool _localUserJoined = false;
  RtcEngine? _engine;
  List<QueryDocumentSnapshot> _chatDocs = [];
  bool _isLoading = true;
  bool _isAgoraInitialized = true;
  bool _isAudioOn = true;
  Map<int, bool>? _speakingUsers;
  Map<int, String>? _userNames;
  FirebaseFirestore? _firestore;
  Stream<QuerySnapshot>? _chatsStream;
  int selected = 0;

  @override
  void initState() {
    super.initState();

    // Initialize class fields
    _remoteUids = {};
    tc = TextEditingController();
    sc = ScrollController();
    _audioPlayer = AudioPlayer();
    _authUser = FirebaseAuth.instance.currentUser?.displayName ?? 'Guest';
    _speakingUsers = {};
    _userNames = {};
    _firestore = FirebaseFirestore.instance;

    // Initialize methods
    if (widget.isOnline) {
      initAgora();
    }
    _initializeChatsStream();
    _initializeAudioPlayer();
  }

  void _initializeAudioPlayer() async {
    await _audioPlayer?.setSource(AssetSource('sounds/mp.mp3'));
    await _audioPlayer?.setReleaseMode(ReleaseMode.release);
  }

  void _initializeChatsStream() {
    _chatsStream = _firestore
        ?.collection('code')
        .doc(widget.teamid)
        .collection('chats')
        .orderBy('timestamp', descending: false)
        .snapshots();
    _chatsStream?.listen((snapshot) {
      if (_chatDocs.length < snapshot.docs.length && _chatDocs.isNotEmpty) {
        // New message received, play sound
        _playMessageSound();
      }
      setState(() {
        _chatDocs = snapshot.docs;
        _isLoading = false;
      });
    });
  }

  void _playMessageSound() async {
    await _audioPlayer?.stop();
    await _audioPlayer?.resume();
  }

  Future<void> _sendMessage() async {
    if (tc!.text.isNotEmpty) {
      final message = {
        "sender": _authUser,
        "message": tc?.text,
        "timestamp": FieldValue.serverTimestamp(),
      };
      tc?.clear();
      try {
        await _firestore
            ?.collection('code')
            .doc(widget.teamid)
            .collection('chats')
            .add(message);
      } catch (e) {
        //  print("Error sending message: $e");
      }
    }
  }

  Future<void> initAgora() async {
    try {
      await [Permission.microphone].request();
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(RtcEngineContext(
        appId: ApiKeys().appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));
      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint("local user ${connection.localUid} joined");
            setState(() {
              _localUserJoined = true;
              _userNames?[0] = "You";
            });
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            debugPrint("remote user $remoteUid joined");
            setState(() {
              _remoteUids?.add(remoteUid);
              _userNames?[remoteUid] = "User $remoteUid";
              _speakingUsers?[remoteUid] = false;
            });
          },
          onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
            debugPrint("remote user $remoteUid left channel");
            setState(() {
              _remoteUids?.remove(remoteUid);
              _userNames?.remove(remoteUid);
              _speakingUsers?.remove(remoteUid);
            });
          },
          onAudioVolumeIndication:
              (connection, speakers, speakerNumber, totalVolume) {
            setState(() {
              for (var speaker in speakers) {
                if (speaker.volume! > 5) {
                  _speakingUsers?[speaker.uid!] = true;
                } else {
                  _speakingUsers?[speaker.uid!] = false;
                }
              }
            });
          },
          onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
            debugPrint(
                '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
          },
        ),
      );

      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await _engine!.enableAudioVolumeIndication(
          interval: 200, smooth: 3, reportVad: true);

      await _engine!.joinChannel(
        token: ApiKeys().token,
        channelId: ApiKeys().channel,
        uid: 0,
        options: const ChannelMediaOptions(),
      );
      setState(() {
        _isAgoraInitialized = true;
      });
    } catch (e) {
      print("Error initializing Agora: $e");
    }
  }

  @override
  void dispose() {
    if (_engine != null) {
      _dispose();
    }
    _audioPlayer?.dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    await _engine!.leaveChannel();
    await _engine!.release();
  }

  void _toggleAudio() {
    setState(() {
      _isAudioOn = !_isAudioOn;
    });
    _engine?.enableLocalAudio(_isAudioOn);
  }

  Widget _buildUserList() {
    return Container(
      width: widget.size.width * 0.2,
      color: Colors.grey[900],
      child: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            width: 250,
            height: 60,
            child: SegmentedButtonSlide(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              entries: const [
                SegmentedButtonSlideEntry(
                  icon: Icons.voice_chat,
                  label: "Voice-Chat",
                ),
                SegmentedButtonSlideEntry(
                  icon: Icons.text_fields,
                  label: "Text-Chat",
                ),
              ],
              selectedEntry: selected,
              onChange: (selectednum) {
                setState(() {
                  selected = selectednum;
                });
              },
              colors: SegmentedButtonSlideColors(
                  barColor: Colors.blue.shade500,
                  backgroundSelectedColor: Colors.blue.shade300),
            ),
          ),
          Expanded(
            child: selected == 1 ? _buildChatUI() : _buildVoiceUI(),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceUI() {
    return ListView(
      children: [
        _buildUserTile(0, "You"),
        ..._remoteUids!
            .map((uid) => _buildUserTile(uid, _userNames?[uid] ?? "User $uid")),
      ],
    );
  }

  Widget _buildChatUI() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return _buildUserChats();
  }

  Widget _buildUserTile(int uid, String name) {
    bool isSpeaking = _speakingUsers?[uid] ?? false;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color:
                isSpeaking ? Colors.green.withOpacity(0.3) : Colors.transparent,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
        gradient: LinearGradient(
          colors: isSpeaking
              ? [Colors.green.shade700, Colors.green.shade500]
              : [Colors.grey.shade800, Colors.grey.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSpeaking ? Colors.greenAccent : Colors.white30,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            backgroundColor:
                isSpeaking ? Colors.green.shade300 : Colors.grey.shade600,
            child: Text(
              name[0].toUpperCase(),
              style: TextStyle(
                color: isSpeaking ? Colors.white : Colors.grey.shade300,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSpeaking ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
        trailing: isSpeaking
            ? const Icon(Icons.mic, color: Colors.greenAccent)
            : const Icon(Icons.mic_off, color: Colors.white30),
      ),
    );
  }

  Widget _buildUserChats() {
    return SizedBox(
      height: widget.size.height * 0.899,
      child: Column(
        children: [
          Expanded(
            child: _chatDocs.isEmpty
                ? _buildStartChattingMessage()
                : ListView.builder(
                    controller: sc,
                    itemCount: _chatDocs.length,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    itemBuilder: (context, index) {
                      final chat =
                          _chatDocs[index].data() as Map<String, dynamic>;
                      final bool isCurrentUser = chat["sender"] == _authUser;
                      return _buildChatBubble(chat, isCurrentUser);
                    },
                  ),
          ),
          _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(5),
      height: widget.size.height * 0.1,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue[300]!),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: tc,
              cursorColor: Colors.blue,
              style: TextStyle(color: Colors.grey[900]),
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[300],
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[300]!),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
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
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              minimumSize: WidgetStateProperty.all<Size>(const Size(60, 60)),
              alignment: Alignment.center,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChatBubble(Map<String, dynamic> chat, bool isCurrentUser) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        constraints: BoxConstraints(maxWidth: widget.size.width * 0.75),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat["message"],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat["sender"],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[800],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
          children: [
            SizedBox(
              width:
                  widget.isOnline ? widget.size.width * 0.8 : widget.size.width,
              child: Stack(
                children: [
                  ...containers,
                  Positioned(
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: 50,
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: widget.isOnline
                              ? onlineContainers
                                  .map((container) => TextButton.icon(
                                      onPressed: () => _addContainer(
                                          widget.problem,
                                          container['name'],
                                          container['icon'],
                                          container['color']),
                                      icon: Icon(container['icon'],
                                          color: container['color']),
                                      label: Text(container['name'],
                                          style: const TextStyle(
                                              color: Colors.white))))
                                  .toList()
                              : availableContainers
                                  .map(
                                    (container) => TextButton.icon(
                                      onPressed: () => _addContainer(
                                          widget.problem,
                                          container['name'],
                                          container['icon'],
                                          container['color']),
                                      icon: Icon(container['icon'],
                                          color: container['color']),
                                      label: Text(
                                        container['name'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.isOnline && _isAgoraInitialized) _buildUserList(),
          ],
        ),
        floatingActionButton:
            widget.isOnline && _isAgoraInitialized && selected == 0
                ? Row(mainAxisSize: MainAxisSize.min, children: [
                    FloatingActionButton(
                      onPressed: _toggleAudio,
                      backgroundColor: Colors.blue[400],
                      child: Icon(_isAudioOn ? Icons.mic : Icons.mic_off),
                    ),
                    SizedBox(width: 10),
                    InviteFriendsButton(
                      title:
                          "${(FirebaseAuth.instance.currentUser?.displayName?.split(' ').first ?? 'User')}'s Inviting",
                      body: 'The Team code is ${widget.teamid}',
                    )
                  ])
                : null);
  }

  void _addContainer(
      Problem problem, String name, IconData icon, MaterialColor color) {
    if (name == "Solutions") {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Submissions(
          problem: problem,
        ),
      ));
    } else {
      setState(() {
        containers.add(
          DraggableResizableContainer(
            teamid: widget.isOnline ? widget.teamid : null,
            problem: problem,
            color: color,
            icon: icon,
            key: Key('container_$name'),
            initialPosition: Offset(20.0 * (containers.length + 1), 70.0),
            initialSize:
                Size(widget.size.width * 0.3, widget.size.height * 0.3),
            minSize: const Size(100, 100),
            maxSize: Size(widget.size.width * 0.9, widget.size.height * 0.9),
            onRemove: _removeContainer,
            label: name,
            returnToButtonBar: _returnToButtonBar,
            bringToFront: _bringContainerToFront,
          ),
        );
        widget.isOnline
            ? onlineContainers
                .removeWhere((container) => container['name'] == name)
            : availableContainers
                .removeWhere((container) => container['name'] == name);
      });
    }
  }

  void _removeContainer(Key key) {
    setState(() {
      containers.removeWhere((container) => container.key == key);
    });
  }

  void _returnToButtonBar(String name, IconData icon, MaterialColor color) {
    setState(() {
      containers
          .removeWhere((container) => container.key == Key('container_$name'));
      if (!availableContainers.any((container) => container['name'] == name)) {
        availableContainers.add({'name': name, 'icon': icon, 'color': color});
      }
      if (!onlineContainers.any((container) => container['name'] == name)) {
        onlineContainers.add({'name': name, 'icon': icon, 'color': color});
      }
    });
  }

  void _bringContainerToFront(Key key) {
    setState(() {
      int index = containers.indexWhere((container) => container.key == key);
      if (index != -1) {
        Widget container = containers.removeAt(index);
        containers.add(container);
      }
    });
  }

  Widget _buildStartChattingMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "Start chatting",
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Send a message to begin the conversation",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
