import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

var _token;

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

generateToken() async {
  await _firebaseMessaging.getToken().then((token) {
    _token = token;
    print(_token);
  });
}

getToken() {
  return _token;
}

sendEmail(text) async {
  var emails = [];
  await Firestore.instance.collection('emails').getDocuments().then(
    (value) {
      value.documents.forEach((element) {
        if (element.data['value'] == true) {
          emails.add(element.data['email']);
        }
      });
    },
  );

  String username = 'aqumosysmonitoring@gmail.com';
  String password = 'UUM_AquMoSys2020';

  final smtpServer = gmail(username, password);
  // Creating the Gmail server

  // Create our email message.
  final message = Message()
    ..from = Address(username)
    // ..recipients.add('zaki23newton@gmai.com') //recipent email
    ..ccRecipients.addAll(emails) //cc Recipents emails
    // ..bccRecipients
    //     .add(Address('bccAddress@example.com')) //bcc Recipents emails
    ..subject = 'AquMoSys Alert' //subject of the email
    ..text = text; //body of the email

  try {
    final sendReport = await send(message, smtpServer);
    print(
        'Message sent: ' + sendReport.toString()); //print if the email is sent
  } on MailerException catch (e) {
    print(
        'Message not sent. \n' + e.toString()); //print if the email is not sent
    // e.toString() will show why the email is not sending
  }
}

sendNotification(text) async {
  var emails = [];
  await Firestore.instance.collection('emails').getDocuments().then(
    (value) {
      value.documents.forEach((element) {
        if (element.data['value'] == true) {
          emails.add(element.data['email']);
        }
      });
    },
  );

  String username = 'aqumosysmonitoring@gmail.com';
  String password = 'UUM_AquMoSys2020';

  final smtpServer = gmail(username, password);
  // Creating the Gmail server

  // Create our email message.
  final message = Message()
    ..from = Address(username)
    // ..recipients.add('zaki23newton@gmai.com') //recipent email
    ..ccRecipients.addAll(emails) //cc Recipents emails
    // ..bccRecipients
    //     .add(Address('bccAddress@example.com')) //bcc Recipents emails
    ..subject = 'AquMoSys Alert' //subject of the email
    ..text = text; //body of the email

  try {
    final sendReport = await send(message, smtpServer);
    print(
        'Message sent: ' + sendReport.toString()); //print if the email is sent
  } on MailerException catch (e) {
    print(
        'Message not sent. \n' + e.toString()); //print if the email is not sent
    // e.toString() will show why the email is not sending
  }

  await Firestore.instance.collection('tokens').getDocuments().then((value) {
    var tokens = value.documents;
    print(tokens[0].data);
    tokens.forEach((token) async {
      if (token.data['value'] == true) {
        await Dio().post(
          'https://fcm.googleapis.com/fcm/send',
          options: Options(
            headers: {
              'Authorization':
                  'key=AAAAa8lKikM:APA91bFQ5Hc0Y2BrArNF8FE8DYj96uveDT0kQPpZMfTyKwaLaix9tArowwTlF0h6rJ2ThIp99pgc4uQuX60sKcBpTccjWCQGcXhQ4-IgVfKWdpCdF9qzukrc-z_pw-vPj3tDm3VRnOdS',
            },
          ),
          data: {
            "notification": {
              "title": "Threshold Alert",
              "body": text,
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
            },
            // "data": {"name": "Coba", "age": 25},
            "to": token['token']
          },
        ).then((value) {
          print(value.data);
          return true;
        }).catchError((e) {
          print(e);
        });
      }
    });
  });

  Firestore.instance.collection('emails').getDocuments().then((value) {
    var emails = value.documents;
    print(emails[0].data);
    print(emails.length);
  });

  print(text);
}
