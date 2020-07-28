import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataProvider extends ChangeNotifier {
  double _minTemp = -55;
  double _maxTemp = 125;
  double _minTurb = 0;
  double _maxTurb = 100;
  double _minPh = 0;
  double _maxPh = 14;
  double _minHum = 0;
  double _maxHum = 100;

  double get minTemp => _minTemp;
  double get maxTemp => _maxTemp;
  double get minTurb => _minTurb;
  double get maxTurb => _maxTurb;
  double get minPh => _minPh;
  double get maxPh => _maxPh;
  double get minHum => _minHum;
  double get maxHum => _maxHum;

  setData(double minTe, double maxTe, double minTu, double maxTu, double minP,
      double maxP, double minH, double maxH) async {
    print('minnte');
    print(minTe);

    _minTemp = minTe;
    _maxTemp = maxTe;
    _minTurb = minTu;
    _maxTurb = maxTu;
    _minPh = minP;
    _maxPh = maxP;
    _minHum = minH;
    _maxHum = maxH;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('minTemp', minTe);
    await prefs.setDouble('maxTemp', maxTe);
    await prefs.setDouble('minTurb', minTu);
    await prefs.setDouble('maxTurb', maxTu);
    await prefs.setDouble('minPh', minP);
    await prefs.setDouble('maxPh', maxP);
    await prefs.setDouble('minHum', minH);
    await prefs.setDouble('maxHum', maxH);

    print(prefs.getDouble('minTemp'));

    notifyListeners();
  }

  getInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _minTemp = prefs.getDouble('minTemp') ?? _minTemp;
    _maxTemp = prefs.getDouble('maxTemp') ?? _maxTemp;
    _minTurb = prefs.getDouble('minTurb') ?? _minTurb;
    _maxTurb = prefs.getDouble('maxTurb') ?? _maxTurb;
    _minPh = prefs.getDouble('minPh') ?? _minPh;
    _maxPh = prefs.getDouble('maxPh') ?? _maxPh;
    _minHum = prefs.getDouble('minHum') ?? _minHum;
    _maxHum = prefs.getDouble('maxHum') ?? _maxHum;
    print('get initial data');
    print(prefs.getDouble('minTemp'));
    print(_minTemp);
    print('yoi');
    notifyListeners();
  }
}
