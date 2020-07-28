import 'package:aquamonitoring/fcm.dart';
import 'package:aquamonitoring/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);

    Future getNotif() async {
      var tempLocal = true;
      var tempEmail = true;

      await Firestore.instance
          .collection('tokens')
          .document(getToken())
          .get()
          .then((value) {
        if (value.data != null) {
          tempLocal = value.data['value'];
        }
      });

      if (authProvider.currentEmail.isNotEmpty) {
        await Firestore.instance
            .collection('emails')
            .document(authProvider.currentEmail)
            .get()
            .then((value) {
          if (value != null) {
            tempEmail = value.data['value'];
          }
        }).catchError((onError) {});

        print(tempEmail);
      }

      print('tempLocal: $tempLocal');
      print('tempEmail: $tempEmail');

      return {
        'local': tempLocal,
        'email': tempEmail,
      };
    }

    return Scaffold(
      backgroundColor: Colors.blue[500],
      //FONTCHANGE appbar
      appBar: AppBar(
        title: Text('Notifications',
            style: GoogleFonts.droidSans(
                textStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ))),
      ),
      body: FutureBuilder(
        future: getNotif(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var local = snapshot.data['local'];
            var email = snapshot.data['email'];

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    color: Colors.white,
                    child: SwitchListTile(
                      value: local,
                      title: Text(
                        'Local Notification',
                        style: TextStyle(
                            // color: Colors.white,
                            ),
                      ),
                      onChanged: (value) async {
                        await Firestore.instance
                            .collection('tokens')
                            .document(getToken())
                            .updateData({'value': value});
                        setState(() {});
                      },
                    ),
                  ),
                  (authProvider.currentEmail.isEmpty)
                      ? SizedBox()
                      : Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          color: Colors.white,
                          child: SwitchListTile(
                            value: email,
                            title: Text(
                              'Email Notification',
                              style: TextStyle(
                                  // color: Colors.white,
                                  ),
                            ),
                            onChanged: (value) async {
                              await Firestore.instance
                                  .collection('emails')
                                  .document(authProvider.currentEmail)
                                  .updateData({'value': value});
                              setState(() {});
                            },
                          ),
                        ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  // MaterialButton(
                  //   minWidth: double.infinity,
                  //   color: kPrimary,
                  //   padding: EdgeInsets.symmetric(
                  //     vertical: 10,
                  //   ),
                  //   child: Text(
                  //     'Save',
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       fontSize: 20,
                  //     ),
                  //   ),
                  //   onPressed: () {},
                  // ),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
