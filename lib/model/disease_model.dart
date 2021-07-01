import 'dart:convert';

Diseases diseaseFromJson(String str) => Diseases.fromJson(json.decode(str));

List<Diseases> diseaseListFromJson(String str) =>
    (json.decode(str) as List).map((i) => Diseases.fromJson(i)).toList();

String diseaseToJson(Diseases diseases) => json.encode(diseases.toJson());

class Diseases {
  String Factor;
  List<String> actions;
  List<String> causes;
  String color;
  String description;
  String infoTitle;
  String info;
  int id;
  List<String> images;
  String name;

//    String remedies;
//    List<Remedies> remedies_list;
    List<String> symptoms;

  Diseases({
    this.Factor,
    this.actions,
    this.causes,
    this.color,
    this.description,
    this.infoTitle,
    this.info,
    this.id,
    this.images,
    this.name,
//    this.remedies,
//    this.remedies_list,
    this.symptoms,
  });

  factory Diseases.fromJson(Map<String, dynamic> json) {
    return Diseases(
      Factor: json['Risk Factor'],
      actions: json['Actions'] != null
          ? new List<String>.from(json['Actions'])
          : null,
      causes:
          json['Causes'] != null ? new List<String>.from(json['Causes']) : null,
      color: json['color'],
      description: json['Description'],
      infoTitle: json['InfoTitle'],
      info: json['Info'],
      id: json['id'],
      images:
          json['images'] != null ? new List<String>.from(json['images']) : null,
      name: json['name'],
//      remedies: json['Remedies'],
//      remedies_list: json['Remedies_list'] != null
//          ? (json['Remedies_list'] as List)
//              .map((i) => Remedies.fromJson(i))
//              .toList()
//          : null,
      symptoms: json['Symptoms'] != null
          ? new List<String>.from(json['Symptoms'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Risk Factor'] = this.Factor;
    data['color'] = this.color;
    data['Description'] = this.description;
    data['id'] = this.id;
    data['name'] = this.name;
//    data['Remedies'] = this.remedies;
    if (this.actions != null) {
      data['Actions'] = this.actions;
    }
    if (this.causes != null) {
      data['Causes'] = this.causes;
    }
    if (this.images != null) {
      data['images'] = this.images;
    }
//    if (this.remedies_list != null) {
//      data['Remedies_list'] =
//          this.remedies_list.map((v) => v.toJson()).toList();
//    }
    if (this.symptoms != null) {
      data['Symptoms'] = this.symptoms;
    }
    return data;
  }
}

class Remedies {
  String description;
  List<String> sub_list;
  String title;

  Remedies({this.description, this.sub_list, this.title});

  factory Remedies.fromJson(Map<String, dynamic> json) {
    return Remedies(
      description: json['description'],
      sub_list: json['sub_list'] != null
          ? new List<String>.from(json['sub_list'])
          : null,
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['title'] = this.title;
    if (this.sub_list != null) {
      data['sub_list'] = this.sub_list;
    }
    return data;
  }
}
