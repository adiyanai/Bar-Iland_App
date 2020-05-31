import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CoursesInformation extends StatefulWidget {
  @override
  _CoursesInformationState createState() => _CoursesInformationState();
}

class _CoursesInformationState extends State<CoursesInformation> {
  InAppWebViewController webView;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
        child: Scaffold(
        appBar: AppBar(
          title: const Text('מידע על קורסים'),
          centerTitle: true,        
        ),
        body: Container(
            child: Column(children: <Widget>[
          Expanded(
              child: InAppWebView(
            initialUrl:
                "https://shoham.biu.ac.il/BiuCoursesViewer/MainPage.aspx",
            initialHeaders: {},
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                  debuggingEnabled: true,
                  preferredContentMode: UserPreferredContentMode.DESKTOP),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
            },
            onLoadStart: (InAppWebViewController controller, String url) {

            },
            onLoadStop: (InAppWebViewController controller, String url) async {

            },
          ))
        ])),
      ),
    );
  }
}

