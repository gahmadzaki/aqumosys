import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[500],
      //FONTCHANGE appbar
      appBar: AppBar(
        title: Text('About',
            style: GoogleFonts.droidSans(
                textStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ))),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: <Widget>[
                        Image(
                          image: AssetImage(
                            'assets/icon/splashscreen.png',
                          ),
                          height: 150,
                          width: 150,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Material(
                            child: Text(
                          'AquMoSys',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue[900],
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  color: Colors.blue[900],
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        'AquMoSys is a simple monitoring app used to monitor the aquaponic system integrated with Internet of Things (IoT).\n \nUsing ESP32 microcontroller with integrated WiFi, connected with four sensors which are pH sensor, Turbidity sensor, Temperature sensor, and Humidity sensor.\n \nAquMoSys equipped with realtime charts, push notification, e-mail alert, and we can manually set the threshold for each of the sensors reading. \n \nHence, we will have no trouble monitoring the condition of our aquaponic system because it can be monitored anytime and anywhere. \n \nIn the end, maintaining aquaponics can be very easy and fun.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
