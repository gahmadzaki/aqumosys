//import 'package:aquamonitoring/constant.dart';
import 'package:aquamonitoring/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:aquamonitoring/models/lit_data.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//import 'package:time_formatter/time_formatter.dart';

import '../models/lit_data.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({Key key, this.lists, this.judul}) : super(key: key);
  final List<LitData> lists;
  final String judul;
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var date = DateTime.now();
  var min;
  var max;
  var unit;
  var appbarTitle;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double tWidht = MediaQuery.of(context).size.width;
    //double tHeight  = MediaQuery.of(context).size.height;

    var index = 0;
    var dataProvider = Provider.of<DataProvider>(context);
    switch (widget.judul) {
      //GANTI JUDUL DI HISTORY
      //GANTI UNIT
      //HISTORY UNIT CHANGE
      //APPBAR ganti appBarTitle
      case 'Temperature':
        min = dataProvider.minTemp;
        max = dataProvider.maxTemp;
        unit = '°C';
        appbarTitle = 'Temperature';

        break;
      case 'Turbidity':
        min = dataProvider.minTurb;
        max = dataProvider.maxTurb;
        unit = 'NTU';
        appbarTitle = 'Turbidity';
        break;
      case 'Humidity':
        min = dataProvider.minHum;
        max = dataProvider.maxHum;
        unit = '%';
        appbarTitle = 'Humidity';
        break;
      case 'pH':
        min = dataProvider.minPh;
        max = dataProvider.maxPh;
        unit = 'pH';
        appbarTitle = 'pH';
        break;
      default:
        min = -200;
        max = 300;
    }

    print('min: $min');
    print('max: $max');

    List<LitData> list = [];
    widget.lists.forEach((element) {
      var time = DateTime.fromMillisecondsSinceEpoch(element.timestamp);
      if (time.day == date.day &&
          time.month == date.month &&
          date.year == time.year) {
        list.add(element);
      }
    });

    print(list.length);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.blue[500],
      //FONTCHANGE appbar
      appBar: AppBar(
          title: Text(appbarTitle,
              style: GoogleFonts.droidSans(
                  textStyle: TextStyle(
                fontWeight: FontWeight.bold,
              )))),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            MaterialButton(
              onPressed: () {},
              child: Text(
                DateFormat('MMMM, d yyyy').format(date).toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.blue[900],
              child: Text(
                "Change Date",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                var datePicked = await DatePicker.showSimpleDatePicker(
                  context,
                  initialDate: DateTime(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(DateTime.now().year + 1),
                  dateFormat: "dd-MMMM-yyyy",
                  locale: DateTimePickerLocale.en_us,
                  looping: true,
                );

                final snackBar = SnackBar(
                    content: Text(
                        "Date Successfully Picked ${DateFormat('MMMM, d yyyy').format(datePicked)}"));
                scaffoldKey.currentState.showSnackBar(snackBar);

                setState(() {
                  date = datePicked;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Card(
                      child: Container(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: tWidht * 0.06),
                          child: Text(
                            'No',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: tWidht * 0.08),
                          child: Text('Date',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: tWidht * 0.29),
                          child: Text('Time',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: tWidht * 0.12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(unit,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                  )

                      // ListTile(
                      //   title: Text(
                      //     'No\t\t\t\t\t\tDate\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tTime',
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      //   trailing: Text(
                      //     unit,
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                      ),
                  list.length == 0
                      ? Container(
                          margin: EdgeInsets.only(
                            top: 20,
                          ),
                          child: Center(
                            child: Text(
                              'No Data Available',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView(
                            children: ListTile.divideTiles(
                              color: Colors.grey,
                              tiles: list.map((data) {
                                index++;
                                var textStyle = TextStyle(
                                    color: Colors.black, fontSize: 14);

                                if (data.data < min || data.data > max) {
                                  textStyle = TextStyle(
                                      color: Colors.red, fontSize: 14);
                                }

                                return Card(
                                    margin: EdgeInsets.all(5),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: tWidht * 0.05),
                                            child: Text(
                                              "$index\t\t\t\t\t\t ${DateFormat('MMMM, d yyyy').format(DateTime.fromMillisecondsSinceEpoch(data.timestamp))}",
                                              style: textStyle,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: tWidht * 0.03),
                                            child: Text(
                                              '\t\t\t\t\t\t\t\t${DateFormat("H:mm:s").format(DateTime.fromMillisecondsSinceEpoch(data.timestamp)).toString()}',
                                              style: textStyle,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 3,
                                                right: tWidht * 0.06),
                                            child: Text(
                                              data.data.toStringAsFixed(2),
                                              style: textStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    // ListTile(
                                    //   leading:
                                    //   Column(
                                    //     crossAxisAlignment: CrossAxisAlignment.end,
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.center,
                                    //     children: <Widget>[
                                    //       Text(
                                    //         "$index\t\t\t\t ${DateFormat('MMMM, d yyyy').format(DateTime.fromMillisecondsSinceEpoch(data.timestamp))}",
                                    //         style: textStyle,
                                    //       ),
                                    //     ],
                                    //   ),
                                    //   title: Column(
                                    //    crossAxisAlignment: CrossAxisAlignment.center,
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.center,
                                    //     children: <Widget>[
                                    //       Text(
                                    //         '\t\t\t\t\t\t\t\t\t${DateFormat("H:mm:s").format(DateTime.fromMillisecondsSinceEpoch(data.timestamp)).toString()}',
                                    //         style: textStyle,
                                    //       ),
                                    //     ],
                                    //   ),
                                    //   trailing: Column(
                                    //     crossAxisAlignment:
                                    //         CrossAxisAlignment.start,
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.start,
                                    //     children: <Widget>[
                                    //       SizedBox(height: 17,),
                                    //       Text(
                                    //         data.data.toStringAsFixed(2),
                                    //         style: textStyle,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    );
                              }).toList(),
                            ).toList(),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
