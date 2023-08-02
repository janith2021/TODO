// import 'dart:js_util';
// import 'dart:html';
import 'dart:math';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:unicons/unicons.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase.initializeApp();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MYAPP());
}

class MYAPP extends StatelessWidget {
  const MYAPP({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller1 = TextEditingController();
    TextEditingController controller2 = TextEditingController();

    adding(BuildContext context) async {
      await FirebaseFirestore.instance.collection("todo").add({
        "title": controller1.text,
        "image":
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.dreamstime.com%2Fphotos-images%2Fnature.html&psig=AOvVaw2VorV7Dt4yS-rAxOB23cyS&ust=1690992549461000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCLDIm6Tsu4ADFQAAAAAdAAAAABAE"
      });
      controller1.text = "";
    }

    update(BuildContext context, String id, String title) {
      controller2.text = title;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controller2,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("todo")
                          .doc(id)
                          .update({"title": controller2.text});
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Update Task",
                      style: GoogleFonts.aBeeZee(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amber)),
                  )
                ],
              ),
            );
          });
    }

    deletion(String docdata) async {
      await FirebaseFirestore.instance
          .collection("todo")
          .doc(docdata)
          .delete()
          .then((value) => print("Document is deleted"),
              onError: (e) => print("$e"));
    }

    Widget _items(QuerySnapshot snapshot) {
      return ListView.builder(
        itemBuilder: (context, index) {
          // final docidget = snapshot;
          // print(docidget.toString());
          final docdata = snapshot.docs[index];
          print(docdata.id);
          // final mapping = docdata.data();
          // print(docdata.get("idField").toString());
          final mapping = docdata.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              tileColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black, width: 4),
              ),
              // leading: Text(
              //   mapping["id"] ?? "No ID",
              //   style: GoogleFonts.aBeeZee(
              //       color: Colors.indigo,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 20),
              // ),
              leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://img.freepik.com/premium-psd/designer-3d-illustration-cartoon-character_561424-218.jpg?w=740")),
              title: Text(
                mapping["title"] ?? "This Field Has Been Removed",
                textAlign: TextAlign.center,
                style: GoogleFonts.aBeeZee(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              // subtitle: Image.network("https://img.freepik.com/premium-vector/man-profile-cartoon_18591-58482.jpg?w=740",fit: BoxFit.fill,),
              style: ListTileStyle.list,
              splashColor: Colors.red,
              trailing: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      update(context, docdata.id, mapping["title"]);
                    },
                    icon: const Icon(UniconsLine.edit),
                  ),
                  IconButton(
                      onPressed: () {
                        deletion(docdata.id);
                      },
                      icon: const Icon(Icons.delete_forever_outlined))
                ],
              ),
            ),
          );
        },
        itemCount: snapshot.docs.length,
      );
    }

    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 229, 101, 220),
          appBar: AppBar(
            backgroundColor: Colors.amberAccent,
            title: Text(
              "TO DO APP",
              style: GoogleFonts.aBeeZee(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  shadows: const [Shadow(color: Colors.blue, blurRadius: 20)],
                  fontSize: 30),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    boxShadow: [BoxShadow(blurRadius: 40)], color: Colors.red),
                // color: Colors.red,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: controller1,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  style: BorderStyle.solid,
                                  color: Color.fromARGB(255, 8, 1, 104)),
                              borderRadius: BorderRadius.circular(10))),
                    )),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        adding(context);
                        // ArtSweetAlert.show(
                        //     context: context,
                        //     artDialogArgs: ArtDialogArgs(
                        //       type: ArtSweetAlertType.success,
                        //       text: "You have Successfully Added Your Task",
                        //       title: "Added",
                        //     ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(blurRadius: 20)]),
                        child: Text(
                          "Add Your Task",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.aBeeZee(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Expanded(
              //     child: ListView.builder(itemCount: 20,itemBuilder: (context, index) {
              //       return ListTile(
              //         title: Text("Your added Text is Here"),
              //       );
              //     })),
              SizedBox(
                height: 40,
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("todo").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return Expanded(
                    child: _items(snapshot.data!),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
