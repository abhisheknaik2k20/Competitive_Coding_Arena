import 'package:competitivecodingarena/AWS/Call_Logic/compiler_call.dart';
import 'package:competitivecodingarena/Stack_OverFlow/WEB/browser_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'dart:ui_web' as ui;
import 'dart:html';

class ProblemDescription extends StatefulWidget {
  final double height;
  final double width;
  final String description;
  final String code;
  final Syntax language;

  const ProblemDescription({
    required this.description,
    required this.code,
    required this.height,
    required this.width,
    required this.language,
    super.key,
  });

  @override
  State<ProblemDescription> createState() => _ProblemDescriptionState();
}

class _ProblemDescriptionState extends State<ProblemDescription> {
  late String _currentCode;
  bool _isEditing = false;
  bool _isRunning = false;
  final TextEditingController _codeEditingController = TextEditingController();
  int _voteCount = 1;

  bool _showConsole = false;
  String _consoleOutput = '';
  bool _hasCompilationError = false;

  @override
  void initState() {
    super.initState();
    _currentCode = widget.code;
    _codeEditingController.text = _currentCode;
  }

  @override
  void dispose() {
    _codeEditingController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      if (_isEditing) {
        _currentCode = _codeEditingController.text;
      } else {
        _codeEditingController.text = _currentCode;
      }
      _isEditing = !_isEditing;
    });
  }

  void _runCode(Syntax syntax, String code) async {
    setState(() {
      _isRunning = true;
      _showConsole = true;
      _consoleOutput = 'Running code...';
      _hasCompilationError = false;
    });

    if (widget.language == Syntax.JAVASCRIPT) {
      try {
        final String viewType =
            'iframe-view-${DateTime.now().millisecondsSinceEpoch}';

        // Detect if code contains React-specific syntax
        bool isReactCode = code.contains('React') ||
            code.contains('react') ||
            code.contains('ReactDOM') ||
            code.contains('jsx') ||
            code.contains('<App') ||
            code.contains('React.createElement') ||
            code.contains('useState') ||
            code.contains('useEffect') ||
            code.contains('import') && code.contains('from');

        String htmlContent;

        if (isReactCode) {
          // For React code, we'll use a simpler approach without relying on import/export
          // Strip out all import statements since we're providing globals
          String processedCode =
              code.replaceAll(RegExp(r'import\s+.*?;', dotAll: true), '');
          // Strip out export statements
          processedCode =
              processedCode.replaceAll(RegExp(r'export\s+default\s+'), '');
          processedCode = processedCode.replaceAll(RegExp(r'export\s+'), '');

          htmlContent = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>React Code Runner</title>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/react/18.2.0/umd/react.development.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/react-dom/18.2.0/umd/react-dom.development.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/babel-standalone/7.23.5/babel.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/framer-motion/10.16.4/framer-motion.js"></script>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css" rel="stylesheet">
  <style>
    body { margin: 0; font-family: Arial, sans-serif; }
    #root { padding: 16px; }
    .error { color: red; padding: 10px; border: 1px solid red; border-radius: 4px; margin-top: 10px; }
  </style>
</head>
<body>
  <div id="root"></div>
  <div id="error-container" style="display: none;" class="error"></div>
  
  <script>
    // Make these libraries available globally
    window.useState = React.useState;
    window.useEffect = React.useEffect;
    window.useRef = React.useRef;
    window.useContext = React.useContext;
    window.useMemo = React.useMemo;
    window.useCallback = React.useCallback;
    window.useReducer = React.useReducer;
    window.motion = window.framerMotion ? window.framerMotion.motion : {};
    window.AnimatePresence = window.framerMotion ? window.framerMotion.AnimatePresence : {};
    
    // Error handler
    window.onerror = function(message, source, lineno, colno, error) {
      const errorContainer = document.getElementById('error-container');
      errorContainer.style.display = 'block';
      errorContainer.innerHTML = '<strong>Error:</strong> ' + message + ' (line ' + lineno + ')';
      console.error(error);
      return true;
    };
  </script>
  
  <script type="text/babel">
    // Wrap in immediately invoked function to create scope
    (function() {
      // Use standard React hooks without imports
      const { useState, useEffect, useRef, useContext, useMemo, useCallback, useReducer } = React;
      const { motion, AnimatePresence } = window.framerMotion || {};
      
      try {
        // The processed code
        ${processedCode}
        
        // Function to find the component to render
        function findComponentToRender() {
          // Check common component names
          if (typeof App !== 'undefined') return App;
          if (typeof Counter !== 'undefined') return Counter;
          if (typeof MyComponent !== 'undefined') return MyComponent;
          
          // Look for any capitalized function that might be a component
          for (const key in this) {
            if (typeof this[key] === 'function' && /^[A-Z]/.test(key) && 
                !['React', 'ReactDOM'].includes(key)) {
              return this[key];
            }
          }
          
          return () => React.createElement('div', {}, 'No component found to render');
        }
        
        // Find and render the component
        const ComponentToRender = findComponentToRender();
        ReactDOM.render(React.createElement(ComponentToRender), document.getElementById('root'));
        
      } catch (error) {
        const errorContainer = document.getElementById('error-container');
        errorContainer.style.display = 'block';
        errorContainer.innerHTML = '<strong>Error:</strong> ' + error.message;
        console.error(error);
      }
    })();
  </script>
</body>
</html>
      ''';
        } else {
          // For non-React code
          bool isCompleteHtml = code.trim().startsWith('<!DOCTYPE') ||
              code.trim().startsWith('<html') ||
              (code.contains('<html') && code.contains('</html>'));

          if (isCompleteHtml) {
            htmlContent = code;
          } else {
            htmlContent = '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Code Runner</title>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/tailwindcss/2.2.19/tailwind.min.css" rel="stylesheet">
  <style>
    body { margin: 0; font-family: Arial, sans-serif; padding: 16px; }
    .error { color: red; padding: 10px; border: 1px solid red; border-radius: 4px; }
  </style>
  <script>
    window.onerror = function(message, source, lineno, colno, error) {
      const errorDiv = document.createElement('div');
      errorDiv.className = 'error';
      errorDiv.innerHTML = '<strong>Error:</strong> ' + message + ' (line ' + lineno + ')';
      document.body.appendChild(errorDiv);
      return true;
    };
  </script>
</head>
<body>
  
    $code
    <script>
      // Execute any JS code that might not be in script tags
      
    </script>
  }
</body>
</html>
      ''';
          }
        }

        ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
          final IFrameElement iframeElement = IFrameElement()
            ..style.border = 'none'
            ..style.height = '100%'
            ..style.width = '100%'
            ..srcdoc = htmlContent;
          return iframeElement;
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return BrowserDialog(viewType: viewType);
          },
        );

        setState(() {
          _isRunning = false;
          _consoleOutput = 'Code executed successfully in the iframe.';
        });
      } catch (e) {
        setState(() {
          _isRunning = false;
          _hasCompilationError = true;
          _consoleOutput = 'Error running code: ${e.toString()}';
        });
      }
    } else {
      Map<String, dynamic> data =
          await callCompiler(context, "cpp", code, showProgress: false);

      setState(() {
        _isRunning = false;
        _consoleOutput = data.toString();
      });
      print(data);
    }
  }

  void _toggleConsole() {
    setState(() {
      _showConsole = !_showConsole;
    });
  }

  void _upvote() {
    setState(() {
      _voteCount++;
    });
  }

  void _downvote() {
    setState(() {
      if (_voteCount > 0) {
        _voteCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 0.6,
      height: widget.height,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _upvote,
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(8),
                      backgroundColor: Colors.grey[300],
                    ),
                    child: Icon(
                      Icons.arrow_drop_up,
                      size: 24,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    "$_voteCount",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _downvote,
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(8),
                      backgroundColor: Colors.grey[300],
                    ),
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 24,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.description,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "Below is sample code which I suspect has something to do with segfault.",
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: _showConsole ? 2 : 4,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _isEditing
                            ? Container(
                                color: Color(0xFF1E1E1E),
                                child: TextField(
                                  controller: _codeEditingController,
                                  maxLines: null,
                                  expands: true,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(16),
                                  ),
                                ),
                              )
                            : SyntaxView(
                                expanded: true,
                                code: _currentCode,
                                syntax: Syntax.YAML,
                                syntaxTheme: SyntaxTheme.vscodeDark(),
                                fontSize: 14,
                                withZoom: true,
                                withLinesCount: true,
                              ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _toggleEditMode,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                backgroundColor: _isEditing
                                    ? Colors.orange
                                    : Colors.blue[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              icon: Icon(_isEditing ? Icons.save : Icons.edit,
                                  size: 18, color: Colors.white),
                              label: Text(_isEditing ? "Save" : "Edit",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: _isRunning
                                  ? null
                                  : () => _runCode(
                                      widget.language,
                                      _isEditing
                                          ? _codeEditingController.text
                                          : _currentCode),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                backgroundColor: Colors.green[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                disabledBackgroundColor: Colors.grey,
                              ),
                              icon: _isRunning
                                  ? SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(Icons.play_arrow,
                                      size: 18, color: Colors.white),
                              label: Text(_isRunning ? "Running" : "Run",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton.icon(
                              onPressed: _toggleConsole,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                backgroundColor: _showConsole
                                    ? Colors.red[700]
                                    : Colors.blue[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              icon: Icon(
                                  _showConsole
                                      ? Icons.keyboard_arrow_down
                                      : Icons.keyboard_arrow_up,
                                  size: 18,
                                  color: Colors.white),
                              label: Text(
                                  _showConsole
                                      ? "Hide Console"
                                      : "Show Console",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                if (_showConsole) ...[
                  SizedBox(height: 8),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Console Output",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Divider(color: Colors.grey[700]),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                _consoleOutput,
                                style: TextStyle(
                                  color: _hasCompilationError
                                      ? Colors.red[300]
                                      : Colors.green[300],
                                  fontFamily: 'monospace',
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
