import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class Console extends ConsumerWidget {
  const Console({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(consoleProvider);
    return SizedBox(
      child: SingleChildScrollView(
        child: Text(
          result,
          style: const TextStyle(color: Colors.white, fontFamily: 'Courier'),
        ),
      ),
    );
  }
}
