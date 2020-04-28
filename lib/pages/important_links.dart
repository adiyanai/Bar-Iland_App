import 'package:bar_iland_app/models/connection.dart';
import 'package:bar_iland_app/models/degree.dart';
import 'package:bar_iland_app/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bar_iland_app/scoped-models/links.dart';

class ImportantLinks extends StatefulWidget {
  final MainModel model;
  ImportantLinks(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ImportantLinksState();
  }
}
class _ImportantLinksState extends State<ImportantLinks>{
  List <Degree> degree_list;
  List<MyTile> listOfTiles;
  @override
  void initState() {
    widget.model.fetchLinks();
     degree_list = widget.model.DegreesList;
     listOfTiles = <MyTile>[
  MyTile(
    degree_list,
  ),];
    super.initState();
  }

 @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Center(
                child: Text('קישורים חשובים'),
              ),
            ),
            body: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return StuffInTiles(listOfTiles[index]);
              },
              itemCount: listOfTiles.length,
            ),
          ),
        ));
  }
}

class StuffInTiles extends StatelessWidget {
  final MyTile myTile;
  StuffInTiles(this.myTile);

  @override
  Widget build(BuildContext context) {
    return _buildTiles(myTile);
  }

  Widget _buildTiles(MyTile t) {
    if (t.children.isEmpty)
    return Directionality(
      textDirection: TextDirection.rtl,
       child: ListTile(
          dense: true,
          enabled: true,
          isThreeLine: false,
          onLongPress: () => print("long press"),
          onTap: () => print("tap"),
          selected: true,
          title: RichText(
              text: TextSpan(
                text: t.title,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                ..onTap = () { launch(t.url);
                },
            ),
          )
    )
    );
    return Directionality(
      textDirection: TextDirection.rtl,
        child: ExpansionTile(
          key: PageStorageKey<int>(8),
          title: Text(t.title),
          children: t.children.map(_buildTiles).toList(),
    ));
    
  }
}

class MyTile {
  String title;
  List<MyTile> children;
  String url;
  List<Degree> degrees;
  MyTile(this.degrees);
}



/*
List<MyTile> listOfTiles = <MyTile>[
  MyTile(
    'מדעי היהדות',
    '',
  ),
  // MyTile(
  //   'מדעי החברה',
  //   <MyTile>[
  //     MyTile("לוגיסטיקה שנה א"),
  //     MyTile('לוגיסטיקה שנה ב'),
  //     MyTile("לוגיסטיקה שנה ג"),
  //     MyTile("כלכלה שנה א"),
  //     MyTile("כלכלה שנה ב"),
  //     MyTile("פסיכולוגיה"),
  //     MyTile("חינוך"),
  //     MyTile("חינוך מיוחד"),
  //     MyTile("ייעוץ חינוכי"),
  //     MyTile("קרימינולוגיה"),
  //     MyTile("מדעי המדינה"),
  //     MyTile("תקשורת"),
  //     MyTile("מדעי ההתנהגות"),
  //     MyTile("סוציולוגיה תואר שני"),
  //     MyTile("סוציולוגיה ואנתרופולוגיה תל אביב"),
  //     MyTile("חינוך בן גוריון"),
  //   ],
  // ),
  // MyTile(
  //   'מדעי הרוח',
  //   <MyTile>[
  //     MyTile('מוזיקה'),
  //     MyTile('מדעי המידע'),
  //     MyTile('היסטוריה'),
  //     MyTile('פילוסופיה'),
  //   ],
  // ),
  // MyTile(
  //   'מדעים מדויקים',
  //   <MyTile>[
  //     MyTile('מדעי המחשב'),
  //     MyTile('מתמטיקה'),
  //     MyTile('פיזיקה'),
  //     MyTile('כימיה'),
  //     MyTile('מדעי המחשב בן גוריון'),
  //   ],
  // ),
  // MyTile(
  //   'הפקולטה להנדסה',
  //   <MyTile>[
  //     MyTile('הנדסת חשמל ומחשבים'),
  //   ],
  // ),
  // MyTile(
  //   'מדעי החיים',
  //   <MyTile>[
  //     MyTile('אופטומטריה'),
  //     MyTile('ביואינפורמטיקה'),
  //     MyTile('מדעי החיים דרייב'),
  //     MyTile("מדעי החיים שנה א' סמסטר א"),
  //     MyTile("מדעי החיים שנה א' סמסטר ב"),
  //     MyTile("מדעי החיים שנה ב' סמסטר א"),
  //     MyTile("מדעי החיים שנה ב' סמסטר ב"),
  //     MyTile("מדעי החיים שנהג"),
  //   ],
  // ),
  // MyTile(
  //   'הפקולטה למשפטים',
  //   <MyTile>[
  //     MyTile('משפטים'),
  //   ],
  // ),
  // MyTile(
  //   'הפקולטה לרפואה',
  //   <MyTile>[
  //     MyTile('רפואה'),
  //   ],
  // ),
  // MyTile(
  //   'לימודים בין תחומיים',
  //   <MyTile>[
  //     MyTile('מדעי המוח'),
  //   ],
  // ),
  // MyTile(
  //   'כללי',
  //   <MyTile>[
  //     MyTile('דרייבים של אוניברסיטת תל אביב'),
  //   ],
  //),
];
*/