import 'dart:convert';

List<LitData> bannerModelFromJson(String str) => List<LitData>.from(json.decode(str).map((x) => LitData.fromJson(x)));

String litDataToJson(List<LitData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LitData {

  LitData({
      this.data,
      this.timestamp
  });


    final double data;
    final int timestamp;

    

    factory LitData.fromJson(Map<String, dynamic> json) => LitData(
       data : json['data'],
       timestamp : json['timestamp'],
    );
      
    Map<String, dynamic> toJson() => 
      {
        'data' : data,
        'timestamp' : timestamp
      };
}