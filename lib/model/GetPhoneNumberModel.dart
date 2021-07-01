class GetPhoneNumberModel {
//    List<Object> html_attributions;
  Results result;
    String status;

//    GetPhoneNumberModel({this.html_attributions, this.result, this.status});
    GetPhoneNumberModel({ this.result, this.status});

    factory GetPhoneNumberModel.fromJson(Map<String, dynamic> json) {
        return GetPhoneNumberModel(
//            html_attributions: json['html_attributions'] != null ? (json['html_attributions'] as List).map((i) => Object.fromJson(i)).toList() : null,
            result: json['result'] != null ? Results.fromJson(json['result']) : null,
            status: json['status'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['status'] = this.status;
//        if (this.html_attributions != null) {
//            data['html_attributions'] = this.html_attributions.map((v) => v.toJson()).toList();
//        }
        if (this.result != null) {
            data['result'] = this.result.toJson();
        }
        return data;
    }
}

class Results {
  String formatted_phone_number;
  String name;
  String rating;

  Results({this.formatted_phone_number, this.name, this.rating});

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      formatted_phone_number: json['formatted_phone_number'],
      name: json['name'],
      rating: json['rating'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['formatted_phone_number'] = this.formatted_phone_number;
    data['name'] = this.name;
    data['rating'] = this.rating;
    return data;
  }
}