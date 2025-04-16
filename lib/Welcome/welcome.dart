import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Welcome/widgets/big_widgets.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;

  @override
  void initState() {
    super.initState();
    _controller1 =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat(reverse: true);
    _controller2 =
        AnimationController(duration: const Duration(seconds: 3), vsync: this)
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 2),
                child: Container(
                    height: MediaQuery.of(context).size.height * 2,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        image: const DecorationImage(
                            image: AssetImage("assets/images/bg.png"),
                            fit: BoxFit.cover)),
                    child: CustomScrollView(slivers: [
                      buildAppBar(context, MediaQuery.of(context).size),
                      buildIntroSection(_controller1),
                      buildExploreSection(_controller2),
                      buildWhycompetitivecodingarenaSection(),
                      buildCompaniesSection()
                    ])))));
  }
}
