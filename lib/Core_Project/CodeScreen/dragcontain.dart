import 'package:competitivecodingarena/Core_Project/CodeScreen/Containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Core_Project/CodeScreen/submission_screen.dart';
import 'package:competitivecodingarena/Core_Project/Contest/OnlineEditor.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/examples/exampleprobs.dart';

List<Map<String, dynamic>> availableContainers = [
  {'name': 'Description', 'icon': Icons.description, 'color': Colors.red},
  {'name': 'Code', 'icon': Icons.code, 'color': Colors.blue},
  {'name': 'Solutions', 'icon': Icons.lightbulb, 'color': Colors.yellow},
  {'name': 'TestCases', 'icon': Icons.check_box, 'color': Colors.green},
  {'name': 'Console', 'icon': Icons.check_box, 'color': Colors.indigo}
];

List<Map<String, dynamic>> onlineContainers = [
  {'name': 'Description', 'icon': Icons.description, 'color': Colors.red},
  {'name': 'OnlineCode', 'icon': Icons.code, 'color': Colors.blue},
  {'name': 'Solutions', 'icon': Icons.lightbulb, 'color': Colors.yellow},
  {'name': 'TestCases', 'icon': Icons.check_box, 'color': Colors.green}
];

class DraggableResizableContainer extends StatefulWidget {
  final String? teamid;
  final Problem problem;
  final Offset initialPosition;
  final Size initialSize;
  final IconData icon;
  final Size minSize;
  final MaterialColor color;
  final Size maxSize;
  final Function(Key) onRemove;
  final String label;
  final Function(String, IconData, MaterialColor) returnToButtonBar;
  final Function(Key) bringToFront;
  final Function(BuildContext, Widget)? onNavigate;

  const DraggableResizableContainer(
      {required this.teamid,
      required this.problem,
      required this.color,
      required this.icon,
      required Key key,
      required this.initialPosition,
      required this.initialSize,
      required this.minSize,
      required this.maxSize,
      required this.onRemove,
      required this.label,
      required this.returnToButtonBar,
      required this.bringToFront,
      this.onNavigate})
      : super(key: key);

  @override
  State<DraggableResizableContainer> createState() =>
      _DraggableResizableContainerState();
}

class _DraggableResizableContainerState
    extends State<DraggableResizableContainer>
    with SingleTickerProviderStateMixin {
  late Offset position;
  late Size size;
  late ScrollController sc;
  final double barHeight = 40.0;
  final tc = TextEditingController();
  String result = "";
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    sc = ScrollController();
    position = widget.initialPosition;
    size = widget.initialSize;
    tc.text =
        'class Solution{\n\t\t\tpublic static void main(String[] args){\n\t\t\t}\n}';
    result = "Run the code First";
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    sc.dispose();
    tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedPositioned(
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
          onTap: () => widget.bringToFront(widget.key!),
          onPanUpdate: (details) => setState(() => position = Offset(
              position.dx + details.delta.dx, position.dy + details.delta.dy)),
          onPanEnd: (details) {
            if (position.dy < 50) {
              widget.returnToButtonBar(widget.label, widget.icon, widget.color);
            }
          },
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 50),
              width: size.width,
              height: size.height + barHeight,
              decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5))
                  ]),
              child: Column(children: [
                _buildHeader(),
                Expanded(child: _buildContent())
              ]))));

  Widget _buildHeader() => Container(
      height: barHeight,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: widget.color.shade800,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(children: [
          Icon(widget.icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Text(widget.label,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16))
        ])
      ]));

  Widget _buildContent() => Container(
      decoration: const BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
      child: Stack(children: [
        Positioned.fill(
            child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(8)),
                child: CupertinoScrollbar(
                    thumbVisibility: true,
                    thickness: 6,
                    controller: sc,
                    child: SingleChildScrollView(
                        controller: sc,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(15),
                        child: _buildContentByLabel())))),
        if (widget.label == 'Description') _buildDescriptionFooter(),
        _buildResizeHandle()
      ]));

  _buildContentByLabel() {
    switch (widget.label) {
      case 'Description':
        return ProblemRenderer.problemToRichText(widget.problem);
      case 'Code':
        return Texteditor(textEditingController: tc, problem: widget.problem);
      case 'TestCases':
        return Testcase(problem: widget.problem);
      case 'Solutions':
        Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => Submissions(problem: widget.problem)));
      case 'Console':
        return const Console();
      case 'OnlineCode':
        return OnlineCodeEditor(teamid: widget.teamid);
      default:
        return const Text('Unknown', style: TextStyle(color: Colors.white));
    }
  }

  Widget _buildDescriptionFooter() => Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: widget.color.shade800,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(8))),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              IconButton(
                  icon: const Icon(Icons.thumb_up_alt_outlined,
                      color: Colors.white),
                  onPressed: null),
              const Text('1.9K', style: TextStyle(color: Colors.white)),
              const SizedBox(width: 15),
              IconButton(
                  icon: const Icon(Icons.thumb_down_alt_outlined,
                      color: Colors.white),
                  onPressed: null)
            ]),
            Row(children: [
              IconButton(
                  icon: const Icon(Icons.comment_outlined, color: Colors.white),
                  onPressed: null),
              IconButton(
                  icon: const Icon(Icons.star_outline, color: Colors.white),
                  onPressed: null)
            ])
          ])));

  Widget _buildResizeHandle() => Positioned(
      right: 0,
      bottom: 0,
      child: GestureDetector(
          onPanUpdate: (details) {
            setState(() => size = Size(
                (size.width + details.delta.dx)
                    .clamp(widget.minSize.width, widget.maxSize.width),
                (size.height + details.delta.dy)
                    .clamp(widget.minSize.height, widget.maxSize.height)));
          },
          child: MouseRegion(
              cursor: SystemMouseCursors.resizeDownRight,
              child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          bottomRight: Radius.circular(8))),
                  child: const Icon(Icons.drag_handle,
                      size: 15, color: Colors.white54)))));
}
