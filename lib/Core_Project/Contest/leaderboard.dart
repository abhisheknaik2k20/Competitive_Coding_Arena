import 'dart:async';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  final Size size;
  const Categories({
    required this.size,
    super.key,
  });

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  late ScrollController scrollController;
  double counter = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  final List<String> randomNames =
      List.generate(25, (index) => faker.internet.userName());
  final List<String> randommessages =
      List.generate(25, (index) => faker.lorem.sentence());

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        counter = (counter + 50) % 800;
        scrollController.animateTo(counter,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: widget.size.height * 0.74,
            child: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: ListView.builder(
                controller: scrollController,
                itemCount: 25,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Category(
                    title: randomNames[index],
                    numOfItems: index,
                    imageUrl: randommessages[index],
                    press: () {},
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final String title;
  final int numOfItems;
  final VoidCallback press;
  final String? imageUrl;

  const Category({
    super.key,
    required this.title,
    required this.numOfItems,
    required this.press,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Numbered badge with conditional styling
              Text(
                "${numOfItems + 1}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: numOfItems < 3 ? Colors.amber : Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: numOfItems < 3
                        ? Colors.amber.withOpacity(0.7)
                        : Colors.blueAccent.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrls[numOfItems % 4]),
                  radius: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "3456",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "Popular",
                            style: TextStyle(
                              color: Colors.blueAccent.shade100,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<String> imageUrls = [
  "https://cdn-icons-png.flaticon.com/128/3135/3135715.png",
  "https://cdn-icons-png.flaticon.com/128/6997/6997662.png",
  "https://cdn-icons-png.flaticon.com/128/1999/1999625.png",
  "https://cdn-icons-png.flaticon.com/128/11498/11498793.png",
];
