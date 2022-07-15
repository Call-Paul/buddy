import 'package:flutter/material.dart';

/**
 * Diese Klasse erstellt den NavDrwaer auf den vom Homescreen zugegriffen werden kann.
 * Hier kann der Benutzer auswählen,
 * ob er Informationen zu Unternehmen, Branchen oder Projekten angezeigt bekommen möchte.
 *
 * @author Paul Franken winf104387
 */
class NavDrawer extends StatefulWidget {

  final ValueChanged onResult;
  //speichert, welcher Filter ausgewählt ist.
   int value;
   NavDrawer({required this.onResult, required this.value});

  @override
  _NavDrawer createState() => _NavDrawer();
}

class _NavDrawer extends State<NavDrawer> {


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Stack(
          children:[
            ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: const Text(
                  'Modus wählen',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    widget.value = 0;
                    widget.onResult(0);
                    Navigator.pop(context);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: widget.value == 0 ? const Color.fromRGBO(211, 211, 211, 0.3) : Colors.transparent,
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
                          color: Color.fromRGBO(255,0,5,1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Text('Projekte         ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SansSerif',
                            color: Color.fromRGBO(0, 92, 169, 1),
                          )),
                      Container(
                        child: widget.value == 0
                            ? Container(
                                margin: const EdgeInsets.only(left: 30),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(195, 118, 75, 1)),
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
                    widget.value = 1;
                    widget.onResult(1);
                    Navigator.pop(context);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: widget.value == 1 ? const Color.fromRGBO(211, 211, 211, 0.3) : Colors.transparent,
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
                          color: Color.fromRGBO(0, 48, 99, 1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Text('Unternehmen',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SansSerif',
                            color: Color.fromRGBO(0, 92, 169, 1),
                          )),
                      Container(
                        child: widget.value == 1
                            ? Container(
                                margin: const EdgeInsets.only(left: 30),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(195, 118, 75, 1)),
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
                    widget.value = 2;
                    widget.onResult(2);
                    Navigator.pop(context);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: widget.value == 2 ? const Color.fromRGBO(211, 211, 211, 0.3) : Colors.transparent,
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
                          color: Color.fromRGBO(227, 227, 227, 1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Text('Branche         ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SansSerif',
                            color: Color.fromRGBO(0, 92, 169, 1),
                          )),
                      Container(
                        child: widget.value == 2
                            ? Container(
                                margin: const EdgeInsets.only(left: 30),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(195, 118, 75, 1)),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset("assets/f_logo.jpg", ),
            ),
        ]
        ),
      ),
    );
  }


}
