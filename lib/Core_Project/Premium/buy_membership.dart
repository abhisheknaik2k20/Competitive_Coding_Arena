import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_web/razorpay_web.dart';

class BuyMembership extends StatefulWidget {
  const BuyMembership({super.key});

  @override
  State<BuyMembership> createState() => _BuyMembershipState();
}

class _BuyMembershipState extends State<BuyMembership>
    with TickerProviderStateMixin {
  late Razorpay _razorpay;
  late AnimationController _scaleController;
  late AnimationController _translateController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _translateAnimation;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _translateController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation =
        Tween<double>(begin: 1, end: 1.05).animate(_scaleController);
    _translateAnimation =
        Tween<Offset>(begin: const Offset(0, 50), end: Offset.zero).animate(
      CurvedAnimation(parent: _translateController, curve: Curves.easeOut),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaleController.forward();
      _translateController.forward();
    });
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Successful: ${response.paymentId}'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'isPremium': true,
          'last_payment_id': response.paymentId,
          'premium_start_date': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Error updating membership status. Please contact support.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.message}'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External Wallet Selected: ${response.walletName}'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void openCheckout(double amount) {
    var options = {
      'key': 'rzp_test_z2nMV0mDcEcGCQ',
      'amount': amount * 100,
      'name': 'Competitive Coding Arena',
      'description': 'Payment for Subscription',
      'prefill': {
        'contact': '8830762624',
        'email': 'abhisheknaik2k20@gmail.com'
      },
      'external': {
        'wallets': ['paytm', 'googlepay']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
    _scaleController.dispose();
    _translateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          const LogoCaption(),
          Positioned(
            top: size.height * 0.35,
            left: size.width * 0.22,
            child: AnimatedBuilder(
              animation:
                  Listenable.merge([_scaleAnimation, _translateAnimation]),
              builder: (context, child) {
                return Transform.translate(
                  offset: _translateAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: PricingOption(
                title: 'Monthly',
                price: '₹35',
                description:
                    'Down from ₹39/month.\nOur monthly plan grants access to all premium features, the best plan for short-term.',
                isPopular: false,
                onSubscribe: () => openCheckout(35),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.35,
            right: size.width * 0.22,
            child: AnimatedBuilder(
              animation:
                  Listenable.merge([_scaleAnimation, _translateAnimation]),
              builder: (context, child) {
                return Transform.translate(
                  offset: _translateAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: PricingOption(
                title: 'Yearly',
                price: '₹13.25',
                description:
                    'Our most popular plan previously sold for ₹299 and is now only ₹13.25/month.\n',
                isPopular: true,
                onSubscribe: () => openCheckout(13.25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PricingOption extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final bool isPopular;
  final VoidCallback onSubscribe;

  const PricingOption({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.isPopular,
    required this.onSubscribe,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.25,
      padding: EdgeInsets.all(size.width * 0.02),
      decoration: BoxDecoration(
          color: isPopular ? Colors.orange[100] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[800]!, width: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.016,
                    color: Colors.black),
              ),
              if (isPopular)
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.006,
                      vertical: size.height * 0.005),
                  decoration: BoxDecoration(
                      color: Colors.green[400],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(width: 2, color: Colors.green[900]!)),
                  child: Text('Most popular',
                      style: TextStyle(
                          fontSize: size.width * 0.01, color: Colors.black)),
                ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            isPopular ? 'billed yearly ₹159' : 'billed monthly',
            style: const TextStyle(color: Colors.black),
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            price,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.026,
                color: Colors.black),
          ),
          const Text('/mo', style: TextStyle(color: Colors.black)),
          SizedBox(height: size.height * 0.02),
          Text(description, style: const TextStyle(color: Colors.black)),
          SizedBox(height: size.height * 0.02),
          ElevatedButton(
            onPressed: onSubscribe,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, size.height * 0.05),
            ),
            child: const Text('Subscribe'),
          ),
        ],
      ),
    );
  }
}

class LogoCaption extends StatefulWidget {
  const LogoCaption({super.key});

  @override
  State<LogoCaption> createState() => _LogoCaptionState();
}

class _LogoCaptionState extends State<LogoCaption> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      top: size.height * 0.10,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: size.width * 0.08,
              ),
              SizedBox(
                width: size.width * 0.012,
              ),
              Text(
                "Competitive Coding Arena",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.04,
                ),
              )
            ],
          ),
          Text(
            "Get started with a Subscription that works for you.",
            style: TextStyle(fontSize: size.width * 0.016),
          )
        ],
      ),
    );
  }
}
