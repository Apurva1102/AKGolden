import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SimpleCalender extends StatelessWidget {
  const SimpleCalender({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: CalendarAppBar(),
      ),
    );
  }
}

class CalendarAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CalendarAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(148.0);

  @override
  State<CalendarAppBar> createState() => _CalendarAppBarState();
}

class _CalendarAppBarState extends State<CalendarAppBar> {
  int selectedIndex = 0;
  DateTime now = DateTime.now();
  late DateTime lastDayOfMonth;
  @override
  void initState() {
    super.initState();
    lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 148.0,
      title: Column(
        children: [
          const SizedBox(height: 16.0),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: Row(
              children: List.generate(
                lastDayOfMonth.day,
                (index) {
                  final currentDate =
                      lastDayOfMonth.add(Duration(days: index + 1));
                  final dayName = DateFormat('E').format(currentDate);
                  return Padding(
                    padding: EdgeInsets.only(
                        left: index == 0 ? 16.0 : 0.0, right: 16.0),
                    child: GestureDetector(
                      onTap: () => setState(
                        () {
                          selectedIndex = index;
                        },
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayName.substring(0, 1),
                            style: TextStyle(
                              fontSize: 24.0,
                              color: selectedIndex == index
                                  ? Colors.brown
                                  : Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            "${index + 1}",
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Container(
                            height: 2.0,
                            width: 28.0,
                            color: selectedIndex == index
                                ? Colors.brown
                                : Colors.transparent,
                          ),
                        ],
                      ),
                    ),
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
