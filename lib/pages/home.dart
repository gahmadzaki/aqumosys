import 'package:aquamonitoring/fcm.dart';
import 'package:aquamonitoring/providers/data_provider.dart';
import 'package:aquamonitoring/providers/screen_provider.dart';
import 'package:customgauge/customgauge.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataProvider>(context);
    var screenProvider = Provider.of<ScreenProvider>(context);

    return StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child('AquMoSys').onValue,
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.hasData) {
            DataSnapshot dataValues = snapshot.data.snapshot;

            Map<dynamic, dynamic> values = dataValues.value;

            List daftar = values.values.toList();

            daftar.sort((a, b) {
              return b['timestamp'].compareTo(a['timestamp']);
            });

            var lastData = daftar[0];
            print(lastData);

            print(DateTime.fromMillisecondsSinceEpoch(daftar[0]['timestamp']));

            var notifText = '';

            if (lastData['Temperature'] < data.minTemp) {
              notifText = notifText +
                  ('\nTemperature (${lastData['Temperature'].toStringAsFixed(2)}) below the threshold. ');
            } else if (lastData['Temperature'] > data.maxTemp) {
              notifText = notifText +
                  ('\nTemperature (${lastData['Temperature'].toStringAsFixed(2)}) above the threshold. ');
            }

            if (lastData['Turbidity'] < data.minTurb) {
              notifText = notifText +
                  ('\nTurbidity (${lastData['Turbidity'].toStringAsFixed(2)}) below the threshold. ');
            } else if (lastData['Turbidity'] > data.maxTurb) {
              notifText = notifText +
                  ('\nTurbidity (${lastData['Turbidity'].toStringAsFixed(2)}) above the threshold. ');
            }
            if (lastData['pH'] < data.minPh) {
              notifText = notifText +
                  ('\npH (${lastData['pH'].toStringAsFixed(2)}) below the threshold. ');
            } else if (lastData['pH'] > data.maxPh) {
              notifText = notifText +
                  ('\npH (${lastData['pH'].toStringAsFixed(2)}) above the threshold. ');
            }

            if (lastData['Humidity'] < data.minHum) {
              notifText = notifText +
                  ('\nHumidity (${lastData['Humidity']}) below the threshold. ');
            } else if (lastData['Humidity'] > data.maxHum) {
              notifText = notifText +
                  ('\nHumidity (${lastData['Humidity']}) above the threshold. ');
            }

            if (notifText.isNotEmpty) {
              sendNotification(notifText);
            }

            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.spaceAround,
                  runAlignment: WrapAlignment.spaceAround,
                  runSpacing: 10,
                  children: [
                    InkWell(
                      onTap: () {
                        screenProvider.setCurrentIndex(0);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.375,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Temperature",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                // color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomGauge(
                              // defaultSegmentColor: Colors.white,
                              // needleColor: Colors.white,
                              startMarkerStyle: TextStyle(
                                // color: Colors.white,
                                color: Colors.black,
                              ),
                              endMarkerStyle: TextStyle(
                                // color: Colors.white,
                                color: Colors.black,
                              ),
                              gaugeSize:
                                  MediaQuery.of(context).size.width * 0.4,
                              minValue: -55,
                              maxValue: 125,
                              segments: [
                                GaugeSegment(
                                  'Low',
                                  (125 - -55) / 3,
                                  Colors.red,
                                ),
                                GaugeSegment(
                                  'Medium',
                                  (125 - -55) / 3,
                                  Colors.orange,
                                ),
                                GaugeSegment(
                                  'High',
                                  (125 - -55) / 3,
                                  Colors.green,
                                ),
                              ],
                              currentValue: lastData['Temperature'].toDouble(),
                              valueWidget: Text(
                                "${lastData['Temperature'].toDouble().toStringAsFixed(1)}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              DateFormat('MMMM, d yyyy')
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      lastData['timestamp']))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 12,
                                // color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              DateFormat('HH:mm:ss')
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      lastData['timestamp']))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 12,
                                // color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        screenProvider.setCurrentIndex(1);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.375,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Turbidity",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomGauge(
                              defaultSegmentColor: Colors.black,
                              needleColor: Colors.black,
                              startMarkerStyle: TextStyle(
                                color: Colors.black,
                              ),
                              endMarkerStyle: TextStyle(
                                color: Colors.black,
                              ),
                              gaugeSize:
                                  MediaQuery.of(context).size.width * 0.4,
                              minValue: 0,
                              maxValue: 100,
                              segments: [
                                GaugeSegment(
                                  'Low',
                                  (100 - 0) / 3,
                                  Colors.red,
                                ),
                                GaugeSegment(
                                  'Medium',
                                  (100 - 0) / 3,
                                  Colors.orange,
                                ),
                                GaugeSegment(
                                  'High',
                                  (100 - 0) / 3,
                                  Colors.green,
                                ),
                              ],
                              currentValue: lastData['Turbidity'].toDouble(),
                              valueWidget: Text(
                                "${lastData['Turbidity'].toDouble().toStringAsFixed(1)}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              DateFormat('MMMM, d yyyy')
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      lastData['timestamp']))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              DateFormat('HH:mm:ss')
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      lastData['timestamp']))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        screenProvider.setCurrentIndex(3);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.375,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "pH",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomGauge(
                              defaultSegmentColor: Colors.black,
                              needleColor: Colors.black,
                              startMarkerStyle: TextStyle(
                                color: Colors.black,
                              ),
                              endMarkerStyle: TextStyle(
                                color: Colors.black,
                              ),
                              gaugeSize:
                                  MediaQuery.of(context).size.width * 0.4,
                              minValue: 0,
                              maxValue: 14,
                              segments: [
                                GaugeSegment(
                                  'Low',
                                  (14 - 0) / 3,
                                  Colors.red,
                                ),
                                GaugeSegment(
                                  'Medium',
                                  (14 - 0) / 3,
                                  Colors.orange,
                                ),
                                GaugeSegment(
                                  'High',
                                  (14 - 0) / 3,
                                  Colors.green,
                                ),
                              ],
                              currentValue: lastData['pH'].toDouble(),
                              valueWidget: Text(
                                "${lastData['pH'].toDouble().toStringAsFixed(1)}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              DateFormat('MMMM, d yyyy')
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      lastData['timestamp']))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              DateFormat('HH:mm:ss')
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      lastData['timestamp']))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        screenProvider.setCurrentIndex(4);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.375,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Humidity",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomGauge(
                              defaultSegmentColor: Colors.black,
                              needleColor: Colors.black,
                              startMarkerStyle: TextStyle(
                                color: Colors.black,
                              ),
                              endMarkerStyle: TextStyle(
                                color: Colors.black,
                              ),
                              gaugeSize:
                                  MediaQuery.of(context).size.width * 0.4,
                              minValue: 0,
                              maxValue: 100,
                              segments: [
                                GaugeSegment(
                                  'Low',
                                  (100 - 0) / 3,
                                  Colors.red,
                                ),
                                GaugeSegment(
                                  'Medium',
                                  (100 - 0) / 3,
                                  Colors.orange,
                                ),
                                GaugeSegment(
                                  'High',
                                  (100 - 0) / 3,
                                  Colors.green,
                                ),
                              ],
                              currentValue: lastData['Humidity'].toDouble(),
                              valueWidget: Text(
                                "${lastData['Humidity'].toDouble().toStringAsFixed(1)}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text(
                              DateFormat('MMMM, d yyyy')
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      lastData['timestamp']))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              DateFormat('HH:mm:ss')
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      lastData['timestamp']))
                                  .toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
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

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
