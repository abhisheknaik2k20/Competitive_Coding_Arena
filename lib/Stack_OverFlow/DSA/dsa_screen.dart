import 'package:competitivecodingarena/Core_Project/Problemset/examples/exampleprobs.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/live_submissions.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/problem_description.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/problem_statement.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/problem_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class DSAScreen extends StatefulWidget {
  const DSAScreen({super.key});

  @override
  State<DSAScreen> createState() => _DSAScreenState();
}

class _DSAScreenState extends State<DSAScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InvisibleSpacer(width: width),
          ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Divider(),
                  ProblemTitle(
                      height: height,
                      width: width,
                      title: "How to make a great R reproducible example"),
                  Divider(),
                  ProblemDescription(
                    height: height,
                    width: width,
                    description:
                        "From what I heard or read, segmentation fault occurs when we try to write on read-only memory or writing on unallocated memory. I searched the whole code putting a lot of printf to see where it happens and why but I got no better results.",
                    code: '''
#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

static bool init_rand(void *data, size_t size) {
    FILE *stream = fopen("/dev/urandom", "r");
    if (stream == NULL) {
        perror("Failed to open /dev/urandom");
        return false;
    }

    bool ok = (fread(data, sizeof(uint8_t), size, stream) == size);
    fclose(stream);

    if (!ok) {
        perror("Failed to read random data");
        return false;
    }

    // Deliberately writing to a NULL pointer (Segfault here)
    uint8_t *ptr = NULL;
    ptr[0] = 0xFF;  // 💥 Writing to NULL causes Segfault

    return true;
}

int main() {
    size_t size = 16;
    uint8_t *data = NULL; // 💥 Not allocating memory

    if (init_rand(data, size)) {
        printf("Random data generated successfully.");
    } else {
        printf("Failed to generate random data.");
    }

    free(data); // 💥 Freeing NULL (not a segfault but incorrect)
    return EXIT_SUCCESS;
}

''',
                    language: Syntax.CPP,
                  ),
                  Divider(),
                  ProblemStatement(
                    height: height,
                    width: width,
                    problem: problemexample[1],
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
          LiveSubmissions(width: width)
        ],
      ),
    );
  }
}

class InvisibleSpacer extends StatelessWidget {
  final double width;
  const InvisibleSpacer({required this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(width: width * 0.08);
  }
}
