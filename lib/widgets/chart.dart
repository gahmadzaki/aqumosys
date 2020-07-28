import 'package:aquamonitoring/pages/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:aquamonitoring/models/lit_data.dart';

class ChartWidget extends StatefulWidget {
  ChartWidget({Key key, this.lists, this.judul, this.param}) : super(key: key);

  final List<LitData> lists;

  final String judul;
  final String param;

  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  double maxVal(data) {
    dynamic max = data.first;
    data.forEach((e) {
      if (e.data > max.data) max = e;
    });
    print(max.data);
    return max.data;
  }

  double minVal(data) {
    dynamic max = data.first;
    data.forEach((e) {
      if (e.data < max.data) max = e;
    });
    print(max.data);
    if (max.data > 0) return 0;
    return max.data;
  }

  double _top;
  double _left;

  List<Color> gradientColors = [
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    //UNTUK MENDAPATKAN UKURAN LAYAR
    double tWidth = MediaQuery.of(context).size.width;
    double tHeigth = MediaQuery.of(context).size.height;
    String titleCustom;

    //TEMPAT MENGUBAH POSISI LABEL
    //SESUAIKAN DENGAN KETINGGIAN SUMBU Y
    //
    //ACUAN PENGUBAHAN
    //0.00x DARI UKURAN LAYAR AGAR RESPONSIVE DI SEMUA HP
    switch (widget.judul) {
      case ('pH'):
        _top = tHeigth * 0.007;
        _left = tWidth * 0.015;
        titleCustom = "(pH)";
        break;
      // KODINGAN INI PAKAI JIKA CUSTOMISASI BERBEDA DARI DEFAULT
      case ('Turbidity'):
        _top = tHeigth * 0.007;
        _left = tWidth * 0.015;
        titleCustom = "(NTU)";
        break;
      case ('Temperature'):
        _top = tHeigth * 0.007;
        _left = tWidth * 0.015;
        titleCustom = "(\u00b0C)";
        break;
      case ('Humidity'):
        _top = tHeigth * 0.007;
        _left = tWidth * 0.015;
        titleCustom = "(%)";
        break;
      //DEFAULT DI PAKAI UNTUK POSISI YANG SAMA
      default:
        _top = tHeigth * 0.007;
        _left = tWidth * 0.015;
    }

    return Card(
      color: Colors.grey[200],
      margin: EdgeInsets.symmetric(horizontal: 11, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Card(
            //WARNA CARD
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            //POSISI CARD
            margin: EdgeInsets.symmetric(horizontal: 13, vertical: 5),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    // Card(
                    //   color: Colors.lightBlueAccent.withOpacity(0.9),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            //UKURAN CHART
                            //UBAH 0.8 DAN 0.72 SESUAI KEMAUAN
                            //MAKSUDNYA UKURAN LAYAR DI KALIKAN DENGAN 0.XX
                            width: MediaQuery.of(context).size.width * 0.82,
                            height: MediaQuery.of(context).size.height * 0.72,
                            decoration: const BoxDecoration(),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 20.0,
                                  left: 20.0,
                                  top: 35,
                                  bottom: 120),
                              child: LineChart(
                                mainData(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // ),
                    Positioned(
                        top: _top,
                        left: _left,
                        child: Material(
                            color: Colors.transparent,
                            child: Text(titleCustom,
                                style: TextStyle(
                                  color: Colors.black,
                                )))),
                    Positioned(
                        left: tWidth * 0.77,
                        top: tHeigth * 0.56,
                        child: Material(
                            color: Colors.transparent,
                            child: Text(
                              '(Time)',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ))),
                    Positioned(
                      //POSISI HISTORY
                      top: tHeigth * 0.62,
                      left: tWidth * 0.29,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width * 0.3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Wrapper(
                                      judul: widget.judul,
                                      param: widget.param,
                                      page: 'details')));
                        },
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        color: Colors.blue[900],
                        child: Text(
                          'History',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
      ),
      titlesData: FlTitlesData(
          show: true,
          leftTitles: SideTitles(
              textStyle: const TextStyle(
                  color: Colors.black,
                  //fontWeight: FontWeight.bold,
                  fontSize: 11),
              showTitles: true,
              reservedSize: 28,
              margin: 12,
              interval: (maxVal(widget.lists) * 1.5) / 5),
          bottomTitles: SideTitles(
              textStyle: const TextStyle(
                  color: Colors.black,
                  //fontWeight: FontWeight.bold,
                  fontSize: 11),
              showTitles: true,
              getTitles: (value) {
                switch (value.toInt()) {
                  case 1:
                    return DateFormat('H:mm:s').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            widget.lists[0].timestamp));
                  case 15:
                    return DateFormat('H:mm:s').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            widget.lists[14].timestamp));
                  case 28:
                    return DateFormat('H:mm:s').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            widget.lists[29].timestamp));
                }
                return '';
              })),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xaaddaaff), width: 1)),
      minX: 0,
      maxX: widget.lists.length.toDouble(),
      minY: minVal(widget.lists) * 1.5,
      maxY: maxVal(widget.lists) * 1.5,
      lineBarsData: [
        LineChartBarData(
          colors: [
            Colors.redAccent,
          ],
          spots: widget.lists.asMap().entries.map((e) {
            return FlSpot(e.key.toDouble(), e.value.data.toDouble());
          }).toList(),
          isCurved: true,
          preventCurveOverShooting: true,
          curveSmoothness: 0,
          dotData: FlDotData(show: true),
          barWidth: 4,
          isStrokeCapRound: false,
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(1)).toList(),
          ),
        ),
      ],
    );
  }
}
