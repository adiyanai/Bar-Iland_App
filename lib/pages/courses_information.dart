import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CoursesInformation extends StatefulWidget {
  @override
  _CoursesInformationState createState() => _CoursesInformationState();
}

class _CoursesInformationState extends State<CoursesInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: CustomPage());
  }
}

class CustomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CustomPageState();
  }
}

class CustomPageState extends State<CustomPage> {
  InAppWebViewController webView;

  double progress = 0;
  //display courses information from shoham.biu.ac.il site
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
            child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
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
                onLoadStop:
                    (InAppWebViewController controller, String url) async {
                },
                onProgressChanged: (InAppWebViewController controller, int progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: _buildProgressBar()
            ),
          ],
        ))
      ])),
    ));
  }
//display a circular progress indicator while loading the page
  Widget _buildProgressBar() {
    if (progress != 1.0) {
      return CircularProgressIndicator();
    }
    return Container();
  }
}