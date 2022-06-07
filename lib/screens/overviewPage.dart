import 'package:buddy/screens/details.dart';
import 'package:buddy/services/database.dart';
import 'package:buddy/services/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatefulWidget {
  int mode;
  OverviewPage({required this.mode});

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  Stream? informationStream;

  @override
  void initState() {
    doBeforeLaunch();
    super.initState();
  }

  doBeforeLaunch() async {
    if(widget.mode == 1){
      informationStream = await DataBaseMethods().getCompanyList();
    }else if ( widget.mode == 2){
      informationStream = await DataBaseMethods().getIndustryList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    doBeforeLaunch();
    return Scaffold(
      body: buildHome(context),
    );
  }

  Widget buildHome(BuildContext context) {
    return StreamBuilder(
        stream: informationStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds =
                        (snapshot.data! as QuerySnapshot).docs[index];
                    return buildBucket(context, ds["text"], ds["imgURL"], ds["link"], ds.id, ds["name"]);
                  },
                )
              : const Center(child: CircularProgressIndicator());
        });
  }

  Widget buildBucket(BuildContext context, String text, String imgURL, String plink, String companyId, String name) {
    String link = plink;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      height: 400,
      decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Color.fromRGBO(202, 170, 147, 1),
          ),
          borderRadius: const BorderRadius.all(const Radius.circular(20))),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: const Radius.circular(20),
                topLeft: const Radius.circular(20)),
            child: Image.network(
              imgURL,
              fit: BoxFit.fill,
              height: 200.0,
              width: double.infinity,
            ),
          ),
          Flexible(
            child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 10,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SansSerif',
                    color: Color.fromRGBO(52, 95, 104, 1),
                  ),
                  textAlign: TextAlign.center,
                )),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              onPressed: () { Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsPage(
                        text: text,
                        link: link,
                        imgURL: imgURL,
                        Id: companyId,
                        name: name,
                        mode: widget.mode,
                      )));},

              icon: const Icon(Icons.arrow_forward),
              label: Text("Mehr..."),
              heroTag: null,
              backgroundColor: Color.fromRGBO(95, 152, 161, 1),
            ),
          )
        ],
      ),
    );
  }

}
