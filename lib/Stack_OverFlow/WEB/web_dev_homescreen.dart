import 'package:competitivecodingarena/Stack_OverFlow/DSA/live_submissions.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/problem_description.dart';
import 'package:competitivecodingarena/Stack_OverFlow/DSA/problem_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';

class WebDevHomescreen extends StatelessWidget {
  const WebDevHomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
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
                        title: "This is a web-dev Problem to-FIX"),
                    Divider(),
                    ProblemDescription(
                      description: '''
The goal is to implement an efficient state management strategy using React's Context API, Redux, or an alternative solution like Zustand, Jotai, or Recoil. The solution should minimize unnecessary re-renders, provide a clear separation of concerns, and ensure a seamless data flow across components.

Would you like me to add code snippets or suggest a specific approach based on your project’s needs? 
                        ''',
                      code: '''
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Include Tailwind CSS from CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
      // Optional: Configure Tailwind theme
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              primary: '#673AB7',
            }
          }
        }
      }
    </script>
  </head>
  <body class="bg-gray-100 p-6">
    <div class="max-w-md mx-auto bg-white rounded-xl shadow-md overflow-hidden md:max-w-2xl">
      <div class="p-8">
        <div class="uppercase tracking-wide text-sm text-primary font-semibold">Tailwind CSS Demo</div>
        <h1 class="mt-2 text-2xl font-bold text-gray-800">Welcome to Tailwind CSS</h1>
        <p class="mt-2 text-gray-600">Edit the HTML on the left side using Tailwind's utility classes and see the changes instantly.</p>
        
        <div class="mt-4 space-y-4">
          <div class="flex items-center">
            <svg class="h-6 w-6 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
            </svg>
            <p class="ml-2 text-gray-700">Utility-first CSS framework</p>
          </div>
          
          <div class="flex items-center">
            <svg class="h-6 w-6 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
            </svg>
            <p class="ml-2 text-gray-700">Responsive design built-in</p>
          </div>
          
          <div class="flex items-center">
            <svg class="h-6 w-6 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
            </svg>
            <p class="ml-2 text-gray-700">Component-friendly approach</p>
          </div>
        </div>
        
        <button class="mt-6 px-4 py-2 bg-primary text-white rounded hover:bg-purple-700 focus:outline-none focus:ring-2 focus:ring-purple-500 focus:ring-opacity-50" onclick="alert('Button clicked!')">
          Click Me
        </button>
      </div>
    </div>
  </body>
</html>
''',
                      height: height,
                      width: width,
                      language: Syntax.JAVASCRIPT,
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
            LiveSubmissions(width: width)
          ],
        ),
      ),
    );
  }
}

class InvisibleSpacer extends StatelessWidget {
  final double width;
  const InvisibleSpacer({required this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.08,
    );
  }
}
