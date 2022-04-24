import 'dart:convert';

class Details {
  late String PhoneNumber;
  late String Location;

  Details({required this.PhoneNumber, required this.Location});

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      PhoneNumber: json['PhoneNumber'],
      Location: json['Location'],
    );
  }
  String toString() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Location'] = Location;
    data['PhoneNumber'] = PhoneNumber;

    String jsonUser = jsonEncode(data);
    return jsonUser;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, String>();

    data['Location'] = Location;
    data['PhoneNumber'] = PhoneNumber;
    return data;
  }
}
