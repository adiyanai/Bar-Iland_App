import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class EventsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EventsPageState();
  }
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Text(
              'לוח אירועים',
            ),
            SizedBox(
              width: 87,
            ),
            Image.asset(
              'assets/Bar_Iland_line.png',
              height: 35,
            ),
          ]),
        ),
        body: CalendarCarousel(
          weekendTextStyle: TextStyle(
            color: Colors.black,
          ),
          todayButtonColor: Colors.blue,
          selectedDayButtonColor: Colors.green,
          //onDayPressed: (DateTime date, List<Event> events) {},
          weekdayTextStyle: TextStyle(
            color: Colors.blue,
          ),
          locale: 'he',
        ),
      ),
    );
  }
}
