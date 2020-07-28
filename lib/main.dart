import 'dart:ui';
//import 'package:aquamonitoring/constant.dart';
import 'package:aquamonitoring/pages/about.dart';
import 'package:aquamonitoring/pages/home.dart';
import 'package:aquamonitoring/pages/notification_screen.dart';
import 'package:aquamonitoring/pages/setting_screen.dart';
import 'package:aquamonitoring/pages/sign_in_screen.dart';
import 'package:aquamonitoring/pages/wrapper.dart';
import 'package:aquamonitoring/providers/auth_provider.dart';
import 'package:aquamonitoring/providers/data_provider.dart';
import 'package:aquamonitoring/providers/screen_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'fcm.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => ScreenProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AquMoSys',
        theme: ThemeData(
          //FONTCHANGE body
          //GANTI JENIS FONT DI SINI SESUAI DI WEBSITE fonts.google.com
          //GANTI DENGAN NAMA YANG ADA "TEXTTHEME"
          //JIKA TIDAK ADA BERARTI BELUM TERDAFTAR DI LIBRARY
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
          primaryColor: Colors.blue[900],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: CustomSplash(
          imagePath: 'assets/icon/splashscreen.png',
          backGroundColor: Colors.blue[900],
          animationEffect: 'zoom-in',
          logoSize: 200,
          home: MainPage(),
          duration: 2500,
          type: CustomSplashType.StaticDuration,
        ),
        // AnimatedSplash(
        //   imagePath: 'assets/icon/splashscreen.png',
        //   home: MainPage(),
        //   duration: 2500,
        //   type: AnimatedSplashType.StaticDuration,
        // ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    var dataProvider = Provider.of<DataProvider>(context);

    return HomePage(authProvider, dataProvider);
  }
}

class HomePage extends StatefulWidget {
  final AuthProvider authProvider;
  final DataProvider dataProvider;

  HomePage(this.authProvider, this.dataProvider);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _message = '';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  getInit() async {
    await generateToken();
    await Firestore.instance
        .collection('tokens')
        .document(getToken())
        .get()
        .then(
      (value) async {
        print('get token');
        print(value.data);
        print('get token');
        if (!value.exists) {
          await Firestore.instance
              .collection('tokens')
              .document(getToken())
              .setData(
            {
              'token': getToken(),
              'value': true,
            },
          ).then(
            (value) {
              print('token added');
            },
          );
        }
      },
    ).catchError((onError) async {
      print(onError);
      await Firestore.instance
          .collection('tokens')
          .document(getToken())
          .setData(
        {
          'token': getToken(),
          'value': true,
        },
      ).then(
        (value) {
          print('token added');
        },
      );
    });
    await widget.authProvider.getInitialUser();

    await widget.dataProvider.getInitialData();
  }

  void getMessage() {
    print(_message);
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('onMessage');
      print('on message $message');
      setState(() => _message = message["notification"]["title"]);
    }, onResume: (Map<String, dynamic> message) async {
      print('onResume');
      print('on resume $message');
      setState(() => _message = message["notification"]["title"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('onLaunch');
      print('on launch $message');
      setState(() => _message = message["notification"]["title"]);
    });
  }

  @override
  void initState() {
    super.initState();
    getInit();
  }

  // @override
  Widget child = Container(
    child: Center(
      child: Text('Page Not Found'),
    ),
  );

  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    var screenProvider = Provider.of<ScreenProvider>(context);
    var currentIndex = screenProvider.currentIndex;

    Future<void> logoutDialog() async {
      print('current email: ${authProvider.currentEmail}');

      await Firestore.instance
          .collection('emails')
          .document(authProvider.currentEmail)
          .updateData({'value': false});
      setState(() {});

      await authProvider.logout();

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
                  Text('You have successfully signed out'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    switch (currentIndex) {
      case 0:
        child = Wrapper(
          judul: 'Temperature',
          page: 'chart',
          param: 'Temperature',
        );
        break;
      case 1:
        child = Wrapper(
          judul: 'Turbidity',
          page: 'chart',
          param: 'Turbidity',
        );
        break;

      case 2:
        child = Home();
        break;

      case 3:
        child = Wrapper(
          judul: 'pH',
          page: 'chart',
          param: 'pH',
        );
        break;
      case 4:
        child = Wrapper(
          judul: 'Humidity',
          page: 'chart',
          param: 'Humidity',
        );
        break;
    }

    buildSignIn() {
      if (authProvider.currentEmail.isEmpty) {
        return ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.white,
          ),
          title: Text(
            'Sign In',
            style: GoogleFonts.droidSans(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignInScreen()));
          },
        );
      } else {
        return ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.white,
          ),
          title: Text(
            'Sign Out',
            style: GoogleFonts.droidSans(
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          onTap: () {
            logoutDialog();
          },
        );
      }
    }

    var bottomNavigationBar2 = BottomNavigationBar(
      backgroundColor: Colors.blue[900],
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (int index) => screenProvider.setCurrentIndex(index),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: new Image.asset(
              'assets/icon/temperature (2).png',
              height: 25,
              width: 25,
            ),
            title: Text(
              'Temp',
              //FONTCHANGE BOTTOM
              style: GoogleFonts.droidSans(
                fontWeight: FontWeight.bold,
              ),
            )),
        BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: new Image.asset(
              'assets/icon/turbid.png',
              height: 25,
              width: 25,
            ),
            title: Text(
              'Turbidity',
              //FONTCHANGE BOTTOM
              style: GoogleFonts.droidSans(
                fontWeight: FontWeight.bold,
              ),
            )),
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: Icon(
            Icons.home,
            color: Colors.white,
          ),
          title: Text(
            'Home',
            //FONTCHANGE BOTTOM
            style: GoogleFonts.droidSans(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: new Image.asset(
              'assets/icon/ph-1.png',
              height: 25,
              width: 25,
            ),
            title: Text(
              'pH',
              //FONTCHANGE BOTTOM
              style: GoogleFonts.droidSans(
                fontWeight: FontWeight.bold,
              ),
            )),
        BottomNavigationBarItem(
          backgroundColor: Colors.white,
          icon: new Image.asset(
            'assets/icon/humidity.png',
            height: 25,
            width: 25,
          ),
          title: Text(
            'Humidity',
            //FONTCHANGE BOTTOM
            style: GoogleFonts.droidSans(
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
    return Scaffold(
      backgroundColor: Colors.blue[500],
      //FONTCHANGE appbar
      appBar: AppBar(
        //FONTCHANGE
        title: Text(
          'Aquaponic Monitoring System',
          style: GoogleFonts.droidSans(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.settings),
        //     onPressed: () {
        //       Navigator.push(context,
        //           MaterialPageRoute(builder: (context) => SettingScreen()));
        //     },
        //   )
        // ],
      ),
      body: SafeArea(
        child: child,
      ),
      bottomNavigationBar: bottomNavigationBar2,
      drawer: Drawer(
        child: Container(
          color: Colors.blue[500],
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 60.0,
                        height: 60.0,
                        child: ClipPath(
                          child: Image.asset(
                            'assets/icon/splashscreen.png',
                            scale: 0.5,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      authProvider.currentEmail.isEmpty
                          ? SizedBox()
                          : Text(
                              authProvider.currentEmail,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              buildSignIn(),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                title: Text(
                  'Threshold Settings',
                  style: GoogleFonts.droidSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingScreen()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.add_alert,
                  color: Colors.white,
                ),
                title: Text(
                  'Notifications',
                  style: GoogleFonts.droidSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.info,
                  color: Colors.white,
                ),
                title: Text(
                  'About AquMoSys',
                  style: GoogleFonts.droidSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
