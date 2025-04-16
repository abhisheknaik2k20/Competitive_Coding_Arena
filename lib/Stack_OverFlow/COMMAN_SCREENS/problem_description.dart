import 'package:competitivecodingarena/AWS/compiler_call.dart';
import 'package:competitivecodingarena/Stack_OverFlow/WEB/browser_view.dart';
import 'package:competitivecodingarena/Stack_OverFlow/WEB/htmlcss_code_snippets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'dart:ui_web' as ui;
import 'dart:html';

class ProblemDescription extends StatefulWidget {
  final int upvotes;
  final int downvotes;
  final double height;
  final double width;
  final String description;
  final String code;
  final Syntax language;

  const ProblemDescription({
    required this.upvotes,
    required this.downvotes,
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
  bool _isUpvoted = false;
  bool _isDownvoted = false;
  final TextEditingController _codeEditingController = TextEditingController();
  late int _voteCount;

  bool _showConsole = false;
  String _consoleOutput = '';
  bool _hasCompilationError = false;

  @override
  void initState() {
    super.initState();
    setVotesCount();
    _currentCode = widget.code;
    _codeEditingController.text = _currentCode;
  }

  void setVotesCount() {
    if (mounted) {
      setState(() {
        _voteCount = widget.upvotes - widget.downvotes;
      });
    }
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
          String processedCode =
              code.replaceAll(RegExp(r'import\s+.*?;', dotAll: true), '');
          processedCode =
              processedCode.replaceAll(RegExp(r'export\s+default\s+'), '');
          processedCode = processedCode.replaceAll(RegExp(r'export\s+'), '');
          htmlContent = returnHTMLContent(processedCode, true);
        } else {
          bool isCompleteHtml = code.trim().startsWith('<!DOCTYPE') ||
              code.trim().startsWith('<html') ||
              (code.contains('<html') && code.contains('</html>'));

          if (isCompleteHtml) {
            htmlContent = code;
          } else {
            htmlContent = returnHTMLContent(code, false);
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
      Map<String, dynamic> data = await callCompiler(
          context, getLanguage(syntax), code,
          showProgress: false);

      setState(() {
        _isRunning = false;
        _consoleOutput = data.toString();
      });
      print(data);
    }
  }

  String getLanguage(Syntax syntax) {
    switch (syntax) {
      case Syntax.CPP:
        return 'cpp';
      case Syntax.JAVA:
        return 'java';
      default:
        return 'python';
    }
  }

  void _toggleConsole() {
    setState(() {
      _showConsole = !_showConsole;
    });
  }

  void _upvote() {
    setState(() {
      if (_isDownvoted) {
        _isDownvoted = false;
        _voteCount += 2;
      } else if (!_isUpvoted) {
        _voteCount++;
      }
      _isUpvoted = true;
    });
  }

  void _downvote() {
    setState(() {
      if (_isUpvoted) {
        _isUpvoted = false;
        _voteCount -= 2;
      } else if (!_isDownvoted) {
        _voteCount--;
      }
      _isDownvoted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 0.6,
      height: widget.height * 1.5,
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: _upvote,
                    icon: Icon(
                      Icons.arrow_circle_up_sharp,
                      size: 35,
                      color: _isUpvoted ? Colors.blue : Colors.grey,
                    ),
                    constraints: BoxConstraints(minWidth: 30, minHeight: 30),
                    padding: EdgeInsets.zero,
                    splashRadius: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      "$_voteCount",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: _isUpvoted
                            ? Colors.blue
                            : _isDownvoted
                                ? Colors.red
                                : Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _downvote,
                    icon: Icon(
                      Icons.arrow_circle_down_sharp,
                      size: 35,
                      color: _isDownvoted ? Colors.red : Colors.grey,
                    ),
                    constraints: BoxConstraints(minWidth: 30, minHeight: 30),
                    padding: EdgeInsets.zero,
                    splashRadius: 20,
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
