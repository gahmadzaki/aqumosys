import 'package:flutter/material.dart';
import 'package:aquamonitoring/widgets/chart.dart';
import 'package:aquamonitoring/pages/detail_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:aquamonitoring/models/lit_data.dart';

class Wrapper extends StatefulWidget {
  Wrapper({Key key, this.judul, this.param, this.page}) : super(key: key);

  final String judul;
  final String param;
  final String page;

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final dbRef = FirebaseDatabase.instance.reference().child('AquMoSys');
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: dbRef.onValue,
        builder: (context, AsyncSnapshot<Event> snap) {
          List<LitData> lists = [];

          final res = [];

          if (snap.hasData) {
            lists.clear();
            res.clear();
            DataSnapshot dataValues = snap.data.snapshot;

            Map<dynamic, dynamic> values = dataValues.value;

            List daftar = values.values.toList();

            daftar.sort((a, b) {
              return a['timestamp'].compareTo(b['timestamp']);
            });

            for (var item in daftar) {
              var prod = {
                'data': item[widget.param] != null
                    ? item[widget.param].toDouble()
                    : 0.0,
                'timestamp': item['timestamp']
              };

              res.add(prod);
            }

            // print(res);
            // print('test');

            res.reversed;

            List<LitData> listsObjcs =
                res.map((e) => LitData.fromJson(e)).toList();

            lists = listsObjcs.reversed.toList();

            var index = 0;
            List<LitData> chartList = [];
            lists.forEach((element) {
              index++;
              if (index <= 18) {
                chartList.add(element);
              }
            });

            lists = lists.reversed.toList();
            chartList = chartList.reversed.toList();

            print(DateTime.fromMillisecondsSinceEpoch(listsObjcs[0].timestamp));
            print(DateTime.fromMillisecondsSinceEpoch(
                listsObjcs[listsObjcs.length - 1].timestamp));

            if (widget.page == 'chart') {
              return new ChartWidget(
                  lists: chartList, judul: widget.judul, param: widget.param);
            } else {
              return new DetailScreen(
                  lists: lists.reversed.toList(), judul: widget.judul);
            }
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
