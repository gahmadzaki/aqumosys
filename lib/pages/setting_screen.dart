//import 'package:aquamonitoring/constant.dart';
import 'package:aquamonitoring/providers/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var dataProvider = Provider.of<DataProvider>(context);

    return SettingInitial(dataProvider);
  }
}

class SettingInitial extends StatefulWidget {
  final DataProvider _dataProvider;
  SettingInitial(this._dataProvider);

  @override
  _SettingInitialState createState() => _SettingInitialState();
}

class _SettingInitialState extends State<SettingInitial> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double minTemp;
  double maxTemp;
  double minTurb;
  double maxTurb;
  double minPh;
  double maxPh;
  double minHum;
  double maxHum;

  @override
  void initState() {
    super.initState();

    print('init');
    print(widget._dataProvider.minTemp);
    minTemp = widget._dataProvider.minTemp;
    maxTemp = widget._dataProvider.maxTemp;
    minTurb = widget._dataProvider.minTurb;
    maxTurb = widget._dataProvider.maxTurb;
    minPh = widget._dataProvider.minPh;
    maxPh = widget._dataProvider.maxPh;
    minHum = widget._dataProvider.minHum;
    maxHum = widget._dataProvider.maxHum;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    minTemp = widget._dataProvider.minTemp;
    maxTemp = widget._dataProvider.maxTemp;
    minTurb = widget._dataProvider.minTurb;
    maxTurb = widget._dataProvider.maxTurb;
    minPh = widget._dataProvider.minPh;
    maxPh = widget._dataProvider.maxPh;
    minHum = widget._dataProvider.minHum;
    maxHum = widget._dataProvider.maxHum;

    changeFunction(int index, double min, double max) {
      print(index);
      print(min);
      print(max);
      switch (index) {
        case 0:
          minTemp = min;
          maxTemp = max;
          break;
        case 1:
          minTurb = min;
          maxTurb = max;
          break;
        case 2:
          minPh = min;
          maxPh = max;
          break;
        case 3:
          minHum = min;
          maxHum = max;
          break;
        default:
      }

      // setState(() {});
    }

    Future<void> updated() async {
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
                  Text(
                    'Threshold updated',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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

    Future<void> dialog() async {
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
                  Text(
                    'Do you want to save the changes?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  updated();
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    handleSubmit() async {
      await widget._dataProvider.setData(
        (minTemp),
        (maxTemp),
        (minTurb),
        (maxTurb),
        (minPh),
        (maxPh),
        (minHum),
        (maxHum),
      );

      dialog();
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue[500],
      //FONTCHANGE appbar
      appBar: AppBar(
          title: Text('Threshold Setting',
              style: GoogleFonts.droidSans(
                  textStyle: TextStyle(
                fontWeight: FontWeight.bold,
              )))),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Threshold(
              0,
              'temperature',
              'Temperature',
              minTemp,
              maxTemp,
              changeFunction,
            ),
            // Threshold(
            //   'temperature',
            //   'Temperature Maximum',
            //   maxTemp,
            // ),
            SizedBox(
              height: 10,
            ),
            Threshold(
              1,
              'turbiditiy',
              'Turbidity',
              minTurb,
              maxTurb,
              changeFunction,
            ),
            // Threshold(
            //   'turbiditiy',
            //   'Turbidity Maximum',
            //   maxTurb,
            // ),
            SizedBox(
              height: 10,
            ),
            Threshold(
              2,
              'ph-1',
              'pH',
              minPh,
              maxPh,
              changeFunction,
            ),
            // Threshold(
            //   'ph-1',
            //   'pH Maximum',
            //   maxPh,
            // ),
            SizedBox(
              height: 10,
            ),
            Threshold(
              3,
              'humidity',
              'Humidity',
              minHum,
              maxHum,
              changeFunction,
            ),
            // Threshold(
            //   'humidity',
            //   'Humidity Maximum',
            //   maxHum,
            // ),
            Expanded(
              child: SizedBox(),
            ),

            MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.3,
              onPressed: () {
                handleSubmit();
              },
              color: Colors.blue[900],
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class Threshold extends StatefulWidget {
  final index;
  final image;
  final title;
  final minValue;
  final maxValue;
  final function;

  Threshold(this.index, this.image, this.title, this.minValue, this.maxValue,
      this.function);

  @override
  _ThresholdState createState() => _ThresholdState();
}

class _ThresholdState extends State<Threshold> {
  double minValue;
  double maxValue;
  double min;
  double max;

  var division;

  @override
  void initState() {
    super.initState();
    minValue = widget.minValue;
    maxValue = widget.maxValue;

    switch (widget.index) {
      case 0:
        min = -55;
        max = 125;
        division = (max - min) * 2;
        break;
      case 1:
        min = 0;
        max = 100;
        division = (max - min) * 1;
        break;
      case 2:
        min = 0;
        max = 14;
        division = (max - min) * 10;
        break;
      case 3:
        min = 0;
        max = 100;
        division = (max - min) * 2;
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    var format;
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                // bottom: 20,
                ),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              'assets/icon/${widget.image}.png',
              width: 40,
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Material(
                      child: Text(
                    'min',
                    style: TextStyle(fontSize: 10),
                  )),
                  Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width * 0.58,
                    child: SliderTheme(
                      //COLOR SLIDER
                      data: SliderTheme.of(context).copyWith(
                        overlayColor: Colors.blue[300].withOpacity(0.3),
                        activeTrackColor: Colors.blue[300],
                        inactiveTrackColor: Colors.redAccent,
                        thumbColor: Colors.blue[900],
                        trackHeight: 19.0,

                        //valueIndicatorColor: const Color(0xFF0175c2),
                      ),
                      child: frs.RangeSlider(
                        min: min,
                        max: max,
                        lowerValue: widget.minValue,
                        upperValue: widget.maxValue,
                        divisions: division.toInt(),
                        showValueIndicator: true,
                        valueIndicatorMaxDecimals: 1,
                        valueIndicatorFormatter: (int index, double value) {
                          String twoDecimals;
                          switch (widget.title) {
                            case ('Temperature'):
                              {
                                format = ' \u00b0C';
                                twoDecimals = value.toStringAsFixed(1);
                              }
                              break;
                            case ('Turbidity'):
                              {
                                format = ' NTU';
                                twoDecimals = value.toStringAsFixed(0);
                              }
                              break;
                            case ('pH'):
                              {
                                format = ' pH';
                                twoDecimals = value.toStringAsFixed(1);
                              }
                              break;
                            case ('Humidity'):
                              {
                                format = ' %';
                                twoDecimals = value.toStringAsFixed(1);
                              }
                              break;
                            default:
                              twoDecimals = value.toStringAsFixed(2);
                          }

                          return '$twoDecimals $format';
                        },
                        onChanged:
                            (double newLowerValue, double newUpperValue) {
                          // setState(() {
                          //   widget.minValue = newLowerValue;
                          //   widget.maxValue = newUpperValue;
                          // });
                        },
                        onChangeStart:
                            (double startLowerValue, double startUpperValue) {
                          print(
                              'Started with values: $startLowerValue and $startUpperValue');
                        },
                        onChangeEnd:
                            (double newLowerValue, double newUpperValue) {
                          print(
                              'Ended with values: $newLowerValue and $newUpperValue');
                          widget.function(
                              widget.index, newLowerValue, newUpperValue);
                        },
                      ),
                    ),
                  ),
                  Material(
                      child: Text(
                    'max',
                    style: TextStyle(fontSize: 10),
                  )),
                ],
              ),

              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     MaterialButton(
              //       onPressed: () {
              //         setState(() {
              //           widget.value.text =
              //               (double.parse(widget.value.text) - 1).toString();
              //         });
              //       },
              //       minWidth: 0,
              //       padding: EdgeInsets.all(4),
              //       color: kPrimary,
              //       child: Icon(
              //         Icons.remove,
              //         color: Colors.white,
              //       ),
              //     ),
              //     Padding(
              //       padding: EdgeInsets.symmetric(
              //         horizontal: 10,
              //       ),
              //       child: Container(
              //         height: 20,
              //         width: MediaQuery.of(context).size.width * 0.3,
              //         child: TextFormField(
              //           controller: widget.value,
              //           onChanged: (value) {
              //             if (!double.parse(value).isNaN) {
              //               setState(() {
              //                 widget.value.text = value;
              //               });
              //             }
              //           },
              //           keyboardType: TextInputType.number,
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 20,
              //           ),
              //           textAlign: TextAlign.center,
              //           textAlignVertical: TextAlignVertical.center,
              //           decoration: InputDecoration(),
              //         ),
              //       ),
              //     ),
              //     MaterialButton(
              //       onPressed: () {
              //         setState(() {
              //           widget.value.text =
              //               (double.parse(widget.value.text) + 1).toString();
              //         });
              //       },
              //       minWidth: 0,
              //       padding: EdgeInsets.all(4),
              //       color: kPrimary,
              //       child: Icon(
              //         Icons.add,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          )
        ],
      ),
    );
  }
}
