import 'dart:convert';

class User {
  static String email = "jain.ronak198@gmail.com";
  static String firstName = "Ronak";
  static String lastName = "Jain";
  static String userId = "201701419";
  static String lat = "21.2033406";
  static String long = "72.7873944";
  String categoryRequired;

  User({
    this.categoryRequired,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
//    email: json["email"],
//    firstName: json["first_name"],
//    lastName: json["last_name"],
//    userId: json["user_id"],
//    lat: json["lat"],
//    long: json["long"],
    categoryRequired: json["category_required"],
  );

  Map<String, dynamic> toMap() => {
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "user_id": userId,
    "lat": lat,
    "long": long,
    "category_required": categoryRequired,
  };
}


class Worker {
  String firstName;
  String lastName;
  String phoneNo;
  String rating;
  String occupation;
  String lat;
  String long;

  Worker({
    this.firstName,
    this.lastName,
    this.phoneNo,
    this.rating,
    this.occupation,
    this.lat,
    this.long
  });

  factory Worker.fromJson(String str) => Worker.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Worker.fromMap(Map<String, dynamic> json) => Worker(
    firstName: json["first_name"],
    lastName: json["last_name"],
    phoneNo: json["phone_no."],
    rating: json["rating"],
    occupation: json["occupation"],
  );

  Map<String, dynamic> toMap() => {
    "first_name": firstName,
    "last_name": lastName,
    "phone_no.": phoneNo,
    "rating": rating,
    "occupation": occupation,
  };
}