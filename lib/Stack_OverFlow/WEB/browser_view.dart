import 'package:flutter/material.dart';

class BrowserDialog extends StatefulWidget {
  final String viewType;

  const BrowserDialog({super.key, required this.viewType});

  @override
  State<BrowserDialog> createState() => _BrowserDialogState();
}

class _BrowserDialogState extends State<BrowserDialog>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _rotationController;
  late Animation<double> _progressAnimation;

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
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _reloadPage() {
    setState(() {
      _isLoading = true;
    });
    _rotationController.repeat();
    Future.delayed(Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _rotationController.stop();
        _rotationController.reset();
      }
    });
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
                        // New tab button
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
            if (_isLoading)
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value: null,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    minHeight: 3,
                  );
                },
              ),
            Expanded(
              child: Stack(
                children: [
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
                  if (_isLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.white.withOpacity(0.3),
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
