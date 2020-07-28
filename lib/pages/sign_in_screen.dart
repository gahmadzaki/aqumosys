import 'package:aquamonitoring/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);

    Future<void> loginDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('You have successfully signed in'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    handleSubmit() async {
      await Firestore.instance
          .collection('emails')
          .document(emailController.text)
          .setData(
        {'email': emailController.text, 'value': true},
      );

      await authProvider.setUser(emailController.text);

      loginDialog();

      // Navigator.pop(context);
    }

    return Scaffold(
      backgroundColor: Colors.blue[500],

      //FONTCHANGE appbar
      appBar: AppBar(
        title: Text('Sign In',
            style: GoogleFonts.droidSans(
                textStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ))),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email,
                      size: MediaQuery.of(context).size.width * 0.3,
                      color: Colors.blue[900],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'E-mail cannot be empty';
                        }
                        if (!EmailValidator.validate(emailController.text)) {
                          return 'Invalid E-mail Address';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter your E-mail Address',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          handleSubmit();
                        }
                      },
                      minWidth: MediaQuery.of(context).size.width * 0.3,
                      color: Colors.blue[900],
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
