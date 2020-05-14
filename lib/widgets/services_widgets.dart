import 'package:bar_iland_app/services_icons.dart';
import '../models/service.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

Map<String, Icon> mapToIcons() {
  Map<String, Icon> servicesIcons = {
    "חדר רווחה": Icon(ServicesIcons.armchair, size: 20),
    "חדר הנקה": Icon(MaterialCommunityIcons.baby_bottle_outline),
    "מקרר": Icon(Icons.kitchen),
    "מכונת קפה": Icon(MdiIcons.coffeeMaker),
    "מיקרוגל חלבי": Icon(MdiIcons.microwave),
    "מיקרוגל בשרי": Icon(MdiIcons.microwave),
    "מים חמים": Icon(MdiIcons.kettleSteam),
    "מכונת חטיפים": Icon(MdiIcons.cookie),
    "מכונת שתייה": Icon(MdiIcons.bottleSodaClassicOutline),
    "מכונת צילום והדפסה": Icon(MdiIcons.printer),
    "פינות ישיבה ושולחנות": Icon(MaterialCommunityIcons.sofa),
    "נדנדה": Icon(ServicesIcons.swing),
    "מטבחון": Icon(MaterialCommunityIcons.water_pump),
    "משטחי החתלה": Icon(MdiIcons.humanBabyChangingTable),
    "בית קפה": Icon(MaterialCommunityIcons.coffee),
    "מסעדה": Icon(MaterialIcons.restaurant),
    "בנק": Icon(MaterialCommunityIcons.bank),
    "דואר": Icon(MaterialCommunityIcons.mailbox),
    "ציוד משרדי וכלי כתיבה": Icon(MaterialCommunityIcons.pencil),
    "סופר": Icon(MaterialCommunityIcons.cart),
    "חנות בגדים": Icon(MaterialCommunityIcons.shopping),
    "סנדלריה": Icon(MdiIcons.tools),
    "סוכנות נסיעות": Icon(MdiIcons.airplane),
    "ספריה": Icon(MdiIcons.library),
    "מזכירות": Icon(MdiIcons.officeBuilding),
    "שעות פעילות": Icon(MaterialCommunityIcons.clock_outline),
    "טלפון": Icon(MdiIcons.phone),
    "מידע נוסף": Icon(MaterialCommunityIcons.information_outline),
    "מייל": Icon(MaterialCommunityIcons.email_box),
    "אתר": Icon(MaterialCommunityIcons.web),
    "מניין": Icon(MaterialCommunityIcons.book_open_page_variant),
    "זמני תפילות שעון קיץ": Icon(MaterialCommunityIcons.clock_outline, size: 0),
    "זמני תפילות שעון חורף":
        Icon(MaterialCommunityIcons.clock_outline, size: 0),
    "שעון קיץ": Icon(MaterialCommunityIcons.clock_outline),
    "שעון חורף": Icon(MaterialCommunityIcons.clock_outline),
    "מעבדת מחשבים": Icon(Icons.computer),
    "מכשיר החייאה (דפיברילטור)": Icon(MdiIcons.medicalBag),
    "שירותי אבטחה": Icon(MaterialCommunityIcons.security),
  };
  return servicesIcons;
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchCaller(String phoneNumber) async {
  String url = "tel:$phoneNumber";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchMail(String mail) async {
  String url = "mailto:$mail";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

List<Widget> businessesContent(Service service) {
  BusinessService business = service;
  Map<String, Widget> businessInfo = Map<String, Widget>();
  if (business.ActivityTime != "") {
    businessInfo["שעות פעילות"] = Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Text(business.ActivityTime));
  }
  if (business.PhoneNumber != "") {
    businessInfo["טלפון"] = Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: GestureDetector(
        onTap: () {
          _launchCaller(business.PhoneNumber);
        },
        child: Text(
          business.PhoneNumber,
          style: TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline),
        ),
      ),
    );
  }
  if (business.GeneralInfo != "") {
    businessInfo["מידע נוסף"] = Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Text(business.GeneralInfo));
  }
  return (businessInfo.keys).map((infoType) {
    return Container(
      width: 320,
      padding: EdgeInsets.fromLTRB(40, 5, 0, 0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        mapToIcons()[infoType],
        Expanded(child: businessInfo[infoType])
      ]),
    );
  }).toList();
}

List<Widget> welfareContent(Service service) {
  WelfareService welfareRoom = service;
  return welfareRoom.Contains.map((containedService) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 18, 0),
      child: Row(children: [
        mapToIcons()[containedService],
        Text(
          containedService,
          style: TextStyle(
            fontSize: 14,
          ),
        )
      ]),
    );
  }).toList();
}

List<Widget> academicServicesContent(Service service) {
  AcademicService academicService = service;
  Map<String, Widget> academicServiceInfo = {
    "שעות פעילות": Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Text(academicService.ActivityTime)),
    "טלפון": Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: GestureDetector(
        onTap: () {
          _launchCaller(academicService.PhoneNumber);
        },
        child: Text(
          academicService.PhoneNumber,
          style: TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline),
        ),
      ),
    ),
    "מייל": Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: GestureDetector(
        onTap: () {
          _launchMail(academicService.Mail);
        },
        child: Text(
          academicService.Mail,
          style: TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline),
        ),
      ),
    ),
    "אתר": Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: GestureDetector(
        onTap: () {
          _launchURL(academicService.Website);
        },
        child: Text(
          academicService.Website,
          style: TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline),
        ),
      ),
    ),
  };
  return (academicServiceInfo.keys).map((infoType) {
    return Container(
      width: 320,
      padding: EdgeInsets.fromLTRB(40, 5, 0, 0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        mapToIcons()[infoType],
        Expanded(child: academicServiceInfo[infoType])
      ]),
    );
  }).toList();
}

List<Widget> prayerServicesContent(Service service) {
  PrayerService prayerService = service;
  Map<String, Container> prayerServiceInfo = Map<String, Container>();
  prayerServiceInfo = prayersInfo(
      prayerServiceInfo,
      "שעון חורף",
      "זמני תפילות שעון חורף",
      prayerService.ShacharitPrayersWinter,
      prayerService.MinchaPrayersWinter,
      prayerService.ArvitPrayersWinter);

  prayerServiceInfo = prayersInfo(
      prayerServiceInfo,
      "שעון קיץ",
      "זמני תפילות שעון קיץ",
      prayerService.ShacharitPrayersSummer,
      prayerService.MinchaPrayersSummer,
      prayerService.ArvitPrayersSummer);

  return [
    Container(
      child: Column(
          children: (prayerServiceInfo.keys).map((info) {
        return Container(
          padding: EdgeInsets.only(right: 15),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [mapToIcons()[info], prayerServiceInfo[info]]),
        );
      }).toList()),
    )
  ];
}

Map<String, Container> prayersInfo(
    Map<String, Container> prayerServiceInfo,
    String clock,
    String prayerTimes,
    String shacharitPrayers,
    String minchaPrayersWinter,
    String arvitPrayersWinter) {
  if (shacharitPrayers != "" ||
      minchaPrayersWinter != "" ||
      arvitPrayersWinter != "") {
    prayerServiceInfo[clock] = Container(
      child: Text(
        clock,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          decoration: TextDecoration.underline,
        ),
      ),
    );
    List<Text> prayersTexts = [];
    if (shacharitPrayers != "") {
      prayersTexts.add(
        Text(
          "שחרית:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      prayersTexts.add(Text(shacharitPrayers));
    }
    if (minchaPrayersWinter != "") {
      prayersTexts.add(Text(
        "מנחה",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ));
      prayersTexts.add(Text(minchaPrayersWinter));
    }
    if (arvitPrayersWinter != "") {
      prayersTexts.add(Text(
        "ערבית",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ));
      prayersTexts.add(Text(arvitPrayersWinter));
    }
    prayerServiceInfo[prayerTimes] = Container(
      padding: EdgeInsets.only(right: 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: prayersTexts),
    );
  }
  return prayerServiceInfo;
}

List<Widget> computersLabsContent(service) {
  ComputersLabService computersLab = service;
  Map<String, Widget> computersLabInfo = Map<String, Widget>();
  computersLabInfo["שעות פעילות"] = Text(computersLab.ActivityTime);
  if (computersLab.PhoneNumber != "") {
    computersLabInfo["טלפון"] = Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: GestureDetector(
        onTap: () {
          _launchCaller(computersLab.PhoneNumber);
        },
        child: Text(
          computersLab.PhoneNumber,
          style: TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline),
        ),
      ),
    );
  }
  if (computersLab.Mail != "") {
    computersLabInfo["מייל"] = Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: GestureDetector(
        onTap: () {
          _launchMail(computersLab.Mail);
        },
        child: Text(
          computersLab.Mail,
          style: TextStyle(
              color: Colors.blue, decoration: TextDecoration.underline),
        ),
      ),
    );
  }
  return [
    Container(
      child: Column(
          children: (computersLabInfo.keys).map((info) {
        return Container(
          padding: EdgeInsets.only(right: 15),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [mapToIcons()[info], computersLabInfo[info]]),
        );
      }).toList()),
    )
  ];
}

List<Widget> securityServicesContent(service) {
  SecurityService securityService = service;
  Map<String, Widget> securityServiceInfo = Map<String, Widget>();
  securityServiceInfo["שעות פעילות"] = Text("ימי חול: " +
      securityService.WeekdaysActivityTime +
      "\n" +
      "ימי שישי וערבי חג: " +
      securityService.FridaysActivityTime +
      "\n" +
      "שבתות: " +
      securityService.SaturdaysActivityTime +
      "\n");
  securityServiceInfo["טלפון"] = Container(
    width: 300,
    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
    child: Column(children: [
      Row(children: [
        GestureDetector(
          onTap: () {
            _launchCaller(securityService.PhoneNumber);
          },
          child: Text(
            securityService.PhoneNumber,
            style: TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
          ),
        )
      ]),
      Row(children: [
        Text("במצבי חירום: "),
        GestureDetector(
          onTap: () {
            _launchCaller(securityService.EmergencyPhoneNumber);
          },
          child: Text(
            securityService.EmergencyPhoneNumber,
            style: TextStyle(
                color: Colors.blue, decoration: TextDecoration.underline),
          ),
        ),
      ])
    ]),
  );
  return [
    Container(
      child: Column(
          children: (securityServiceInfo.keys).map((info) {
        return Container(
          padding: EdgeInsets.only(right: 15),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [mapToIcons()[info], securityServiceInfo[info]]),
        );
      }).toList()),
    )
  ];
}
