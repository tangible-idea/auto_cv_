import 'dart:convert';

UserModel userModelFromJson(String response) {
  var jsonResponse= json.decode(response);
  var objRoot= UserModel.fromJson(jsonResponse);

  // var mapped= decoded.map((x) => UserModel.fromJson(x));
  // jsonResponse.rec

  return objRoot;
}

String userModelToJson(List<UserModel> data) {
  return json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}

// {
// "name": "JaeJun Lee",
// "headline": "Frontend Programmer",
// "number": "+82 10 2858 4900",
// "email": "slugj2020@gmail.com",
// "location": "South Korea",
// "skillsFrontend": [
// "Dart / Flutter",
// "Java",
// "Javascript (Typescript)"
// ],
// "skillsBackend": [
// "Nest",
// "AWS lambda"
// ],
// "experienceYear": 4
// }
class UserModel {
  String name;
  String headline;
  String location;
  String email;
  String address;
  String phone;
  int experienceYear;
  List<String> skillsFrontend;
  List<String> skillsBackend;

  UserModel({
    this.name = '',
    this.headline= '',
    this.location = '',
    this.email = '',
    this.address = '',
    this.phone = '',
    this.experienceYear = 0,
    List<String>? skillsFrontend,
    List<String>? skillsBackend,
  }) : skillsFrontend = skillsFrontend ?? [],
        skillsBackend = skillsBackend ?? [];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'headline': headline,
      'location': location,
      'email': email,
      'address': address,
      'phone': phone,
      'experienceYear': experienceYear,
      'skillsFrontend': skillsFrontend,
      'skillsBackend': skillsBackend,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      headline: json['headline'] ?? '',
      location: json['location'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      experienceYear: json['experienceYear'] ?? 0,
      skillsFrontend: List<String>.from(json['skillsFrontend'] ?? []),
      skillsBackend: List<String>.from(json['skillsBackend'] ?? []),
    );
  }
}