import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:competitivecodingarena/Core_Project/Problemset/containers/problemset.dart';
import 'package:competitivecodingarena/ImageScr/homeScreen.dart';
import '../styles/styles.dart';

class AdsAndCalenderAndProblems extends StatefulWidget {
  final Size size;
  const AdsAndCalenderAndProblems({required this.size, super.key});

  @override
  State<AdsAndCalenderAndProblems> createState() =>
      _AdsAndCalenderAndProblemsState();
}

class _AdsAndCalenderAndProblemsState extends State<AdsAndCalenderAndProblems> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: widget.size.width * 0.13),
            SizedBox(
              width: widget.size.width * 0.5,
              height: 470,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageRow(widget.size.width * 0.15,
                      widget.size.height * 0.17, imagscr),
                  const SizedBox(height: 25),
                  Text("Study Plan", style: titleTextStyle(context)),
                  const SizedBox(height: 5),
                  _buildInfoRow(widget.size.width * 0.15,
                      widget.size.height * 0.13, imagscr2, text1),
                  const SizedBox(height: 10),
                  _buildInfoRow(widget.size.width * 0.15,
                      widget.size.height * 0.13, imgscr3, text2),
                  const SizedBox(height: 20),
                  const Text("Topics to Explore",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  _buildTopicsRow(widget.size.width * 0.49),
                ],
              ),
            ),
            _buildCalendarColumn(widget.size.width * 0.2, 470),
            SizedBox(width: widget.size.width * 0.1),
          ],
        ),
        ProblemsetMenu(size: widget.size),
      ],
    );
  }

  Widget _buildImageRow(double width, double height, List<String> imageUrls) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (String imageUrl in imageUrls)
          Container(
            clipBehavior: Clip.antiAlias,
            width: width,
            height: height,
            decoration: imageContainerDecoration(imageUrl, context),
          ),
      ],
    );
  }

  Widget _buildInfoRow(double width, double height,
      List<String> assetImagePaths, List<Map<String, String>> texts) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (int i = 0; i < assetImagePaths.length; i++)
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            width: width,
            height: height,
            decoration: containerDecoration(context),
            child: Row(
              children: [
                Image.asset(
                  assetImagePaths[i],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("  ${texts[i]['title']!}",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    Text("   ${texts[i]['subtitle']!}",
                        style: subtitleTextStyle(context)),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTopicsRow(double width) {
    return Row(
      children: [
        SizedBox(
          width: width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (Map<String, dynamic> name in namesofcol)
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey.withOpacity(0.3)
                            : Colors.white.withOpacity(0.1),
                      ),
                      child: Row(
                        children: [
                          Icon(name['icon'], color: name['color'], size: 15),
                          const SizedBox(width: 5),
                          Text(
                            name['title'],
                            style: labelTextStyle(context),
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
    );
  }

  Widget _buildCalendarColumn(double width, double height) {
    return Container(
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      width: width,
      height: height,
      decoration: calendarDecoration(context),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 10),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Day ${DateTime.now().day}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.blue
                                  : Colors.white)),
                ]),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 300,
              child: CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                    calendarViewScrollPhysics:
                        const NeverScrollableScrollPhysics(),
                    controlsHeight: 0,
                    lastMonthIcon: const Icon(Icons.abc, size: 0),
                    nextMonthIcon: const Icon(Icons.abc, size: 0),
                    disableMonthPicker: true,
                    disableModePicker: true,
                    selectedDayHighlightColor: Colors.blue,
                    dayTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    weekdayLabelTextStyle:
                        TextStyle(fontWeight: FontWeight.bold),
                    monthTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    daySplashColor: Colors.blue),
                value: const [],
              ),
            ),
          ),
          _buildOngoingPlanContainer(widget.size.width * 0.19, 135),
        ],
      ),
    );
  }

  Widget _buildOngoingPlanContainer(double width, double height) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: width,
      height: height,
      decoration: ongoingPlanDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ongoing Study Plan", style: progressTextStyle(context)),
          const SizedBox(height: 10),
          Row(
            children: [
              Image.asset('assets/images/sql50.png', height: 80, width: 80),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Plan Name'),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: LinearProgressIndicator(
                          value: 0.2,
                          color: Colors.grey.withOpacity(0.1),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text('20%',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 10)),
                    ],
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      "Continue?",
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SophisticatedCalendar extends StatelessWidget {
  const SophisticatedCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: CalendarDatePicker2(
        config: CalendarDatePicker2Config(
          calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
          controlsHeight: 50,
          // Custom icons for better visual appeal
          lastMonthIcon: Icon(
            Icons.chevron_left_rounded,
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
          nextMonthIcon: Icon(
            Icons.chevron_right_rounded,
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
          disableMonthPicker: true,
          disableModePicker: true,
          selectedDayHighlightColor: Colors.blue.shade400,
          dayTextStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
          selectedDayTextStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          weekdayLabelTextStyle: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white54 : Colors.black54,
            letterSpacing: 1.0,
          ),
          monthTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          dayBorderRadius: BorderRadius.circular(10),

          todayTextStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade400,
          ),

          weekdayLabels: const [
            'Sun',
            'Mon',
            'Tue',
            'Wed',
            'Thu',
            'Fri',
            'Sat'
          ],
          dayTextStylePredicate: ({required date}) {
            // Custom styling for weekends
            if (date.weekday == DateTime.saturday ||
                date.weekday == DateTime.sunday) {
              return TextStyle(
                color: isDarkMode ? Colors.white38 : Colors.black38,
                fontWeight: FontWeight.w500,
              );
            }
            return null;
          },
          // Custom splash effect
          daySplashColor: Colors.blue.shade100.withOpacity(0.3),
        ),
        value: const [],
      ),
    );
  }
}
