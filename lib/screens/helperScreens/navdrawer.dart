import 'package:flutter/material.dart';

class NavDrawer extends StatefulWidget {


  @override
  _NavDrawer createState() => _NavDrawer();
}

class _NavDrawer extends State<NavDrawer> {

  int _value = 0;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: const Text(
                'Modus wählen',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SansSerif',
                  color: Colors.grey,
                ),
              ),
            ),
            InkWell(
              onTap: (){
                setState(() {
                  _value = 0;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: _value == 0 ? const Color.fromRGBO(211, 211, 211, 0.3) : Colors.transparent,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                // BoxDecoration
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 20),
                      width: 40.0,
                      height: 40.0,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(240, 232, 76, 1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Text('Projekte         ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SansSerif',
                          color: Colors.grey,
                        )),
                    Container(
                      child: _value == 0
                          ? Container(
                              margin: const EdgeInsets.only(left: 30),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(255, 136, 27, 1)),
                              child: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.check,
                                    size: 15.0,
                                    color: Colors.white,
                                  )),
                            )
                          : Container(
                              height: 25,
                              margin: const EdgeInsets.only(left: 30),
                              width: 25,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(40),
                                ),
                                border: Border.all(
                                  width: 2,
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                setState(() {
                  _value = 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: _value == 1 ? const Color.fromRGBO(211, 211, 211, 0.3) : Colors.transparent,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 20),
                      width: 40.0,
                      height: 40.0,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(140, 219, 185, 1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Text('Unternehmen',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SansSerif',
                          color: Colors.grey,
                        )),
                    Container(
                      child: _value == 1
                          ? Container(
                              margin: const EdgeInsets.only(left: 30),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(255, 136, 27, 1)),
                              child: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.check,
                                    size: 15.0,
                                    color: Colors.white,
                                  )),
                            )
                          : Container(
                              height: 25,
                              margin: const EdgeInsets.only(left: 30),
                              width: 25,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(40),
                                ),
                                border: Border.all(
                                  width: 2,
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                setState(() {
                  _value = 2;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: _value == 2 ? const Color.fromRGBO(211, 211, 211, 0.3) : Colors.transparent,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 20),
                      width: 40.0,
                      height: 40.0,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(217, 111, 59, 1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Text('Branche         ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SansSerif',
                          color: Colors.grey,
                        )),
                    Container(
                      child: _value == 2
                          ? Container(
                              margin: const EdgeInsets.only(left: 30),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(255, 136, 27, 1)),
                              child: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.check,
                                    size: 15.0,
                                    color: Colors.white,
                                  )),
                            )
                          : Container(
                              height: 25,
                              margin: const EdgeInsets.only(left: 30),
                              width: 25,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(40),
                                ),
                                border: Border.all(
                                  width: 2,
                                  color: Colors.grey,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
