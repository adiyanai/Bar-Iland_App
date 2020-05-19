import 'package:flutter/material.dart';
import 'package:bar_iland_app/scoped-models/main.dart';


class FoundBoard extends StatefulWidget {
  final MainModel model;
  FoundBoard(this.model);


  @override
  State<StatefulWidget> createState() {
    return _FoundBoardState();
  }
}

class _FoundBoardState extends State<FoundBoard> {
   @override
  void initState() {
    super.initState();
  }

     @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/lost_found.jpg'),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Center(
            child: Text("לוח מציאות"),
          ),
        ),
      ),
    );
  }
}