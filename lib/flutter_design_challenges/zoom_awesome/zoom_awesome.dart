import 'package:flutter/material.dart';

class ZoomAwesome extends StatefulWidget {
  const ZoomAwesome({Key? key}) : super(key: key);

  @override
  State<ZoomAwesome> createState() => _ZoomAwesomeState();
}

class _ZoomAwesomeState extends State<ZoomAwesome> {
  List<Offset> blowUpHereList = [];

  void removeParticle(Offset offset) {
    setState(() {
      blowUpHereList.removeWhere((elementOffset) => offset == elementOffset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
      ),
    );
  }
}
