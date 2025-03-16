import 'package:flutter/material.dart';
import 'dart:async';

class BrowserDialog extends StatefulWidget {
  final String viewType;

  const BrowserDialog({super.key, required this.viewType});

  @override
  State<BrowserDialog> createState() => _BrowserDialogState();
}

class _BrowserDialogState extends State<BrowserDialog>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  double _loadingProgress = 0.0;
  String _loadingStatus = "Initializing React components...";
  late AnimationController _rotationController;
  // ignore: unused_field
  late Animation<double> _progressAnimation;
  Timer? _progressTimer;

  final List<String> _loadingSteps = [
    "Initializing React components...",
    "Loading dependencies...",
    "Rendering UI components...",
    "Processing React data...",
    "Applying styles and animations...",
    "Finalizing React content..."
  ];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the rotation and progress simulation
    _rotationController.repeat();
    _simulateLoading();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _rotationController.dispose();
    super.dispose();
  }

  void _simulateLoading() {
    // Simulate loading progress with steps
    const totalDuration = 2000; // 4 seconds total loading time
    const updateInterval = 100; // Update every 100ms
    final steps = _loadingSteps.length;

    _progressTimer =
        Timer.periodic(const Duration(milliseconds: updateInterval), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final elapsedTime = timer.tick * updateInterval;
      final newProgress = elapsedTime / totalDuration;

      if (newProgress >= 1.0) {
        setState(() {
          _loadingProgress = 1.0;
          _isLoading = false;
          _loadingStatus = "React content loaded";
        });
        _rotationController.stop();
        _rotationController.reset();
        timer.cancel();
      } else {
        setState(() {
          _loadingProgress = newProgress;
          // Update message based on progress
          final stepIndex = (newProgress * steps).floor();
          if (stepIndex < steps) {
            _loadingStatus = _loadingSteps[stepIndex];
          }
        });
      }
    });
  }

  void _reloadPage() {
    setState(() {
      _isLoading = true;
      _loadingProgress = 0.0;
      _loadingStatus = "Reloading React components...";
    });

    _rotationController.repeat();
    _progressTimer?.cancel();
    _simulateLoading();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              height: 35,
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5))),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 200,
                          height: 30,
                          margin: EdgeInsets.only(
                            top: 8,
                            left: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 8),
                              Icon(Icons.public,
                                  size: 16, color: Colors.grey[600]),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Browser',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[600]),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.minimize,
                              size: 14, color: Colors.white),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          splashRadius: 14,
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.crop_square,
                              size: 14, color: Colors.white),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          splashRadius: 14,
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        margin: EdgeInsets.only(right: 8, left: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon:
                              Icon(Icons.close, size: 14, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                          padding: EdgeInsets.zero,
                          splashRadius: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back,
                                color: Colors.grey[600], size: 20),
                            onPressed: () {},
                            padding: EdgeInsets.all(4),
                            constraints: BoxConstraints(),
                            splashRadius: 20,
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward,
                                color: Colors.grey[600], size: 20),
                            onPressed: () {},
                            padding: EdgeInsets.all(4),
                            constraints: BoxConstraints(),
                            splashRadius: 20,
                          ),
                          IconButton(
                            icon: AnimatedBuilder(
                              animation: _rotationController,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle:
                                      _rotationController.value * 2 * 3.14159,
                                  child: Icon(
                                    Icons.refresh,
                                    color: _isLoading
                                        ? Colors.blue
                                        : Colors.grey[600],
                                    size: 20,
                                  ),
                                );
                              },
                            ),
                            onPressed: _reloadPage,
                            padding: EdgeInsets.all(4),
                            constraints: BoxConstraints(),
                            splashRadius: 20,
                          ),
                        ],
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.lock, color: Colors.green, size: 16),
                              SizedBox(width: 6),
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(
                                      text: 'https://example.com/content'),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    border: InputBorder.none,
                                    isDense: true,
                                    hintText: 'Enter URL',
                                  ),
                                  style: TextStyle(
                                      color: Colors.grey[800], fontSize: 14),
                                  onSubmitted: (value) {
                                    print('Navigating to: $value');
                                    _reloadPage();
                                  },
                                  textInputAction: TextInputAction.go,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      IconButton(
                        icon: Icon(Icons.more_vert,
                            color: Colors.grey[600], size: 20),
                        onPressed: () {},
                        padding: EdgeInsets.all(4),
                        constraints: BoxConstraints(),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  // Always render the iframe in the background, regardless of loading state
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                    ),
                    child: HtmlElementView(
                      viewType: widget.viewType,
                    ),
                  ),
                  // Conditionally show loading overlay on top of the iframe
                  if (_isLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            // Enhanced progress indicator with text status
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              color: Colors.blue.withOpacity(0.05),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.blue),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        _loadingStatus,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.blue[700]),
                                      ),
                                      Spacer(),
                                      Text(
                                        '${(_loadingProgress * 100).toInt()}%',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.blue[700],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value: _loadingProgress,
                                    backgroundColor: Colors.grey[200],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blue),
                                    minHeight: 5,
                                    borderRadius: BorderRadius.circular(2.5),
                                  ),
                                ],
                              ),
                            ),
                            // Main loading indicator
                            Expanded(
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: CircularProgressIndicator(
                                        value: _loadingProgress,
                                        strokeWidth: 4,
                                        backgroundColor: Colors.grey[200],
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                    ),
                                    SizedBox(height: 24),
                                    Text(
                                      "Loading React Content",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    SizedBox(
                                      width: 240,
                                      child: Text(
                                        _loadingStatus,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
