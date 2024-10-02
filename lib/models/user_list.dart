// To parse this JSON data, do
//
//     final userList = userListFromJson(jsonString);

import 'dart:convert';

UserList userListFromJson(String str) => UserList.fromJson(json.decode(str));

String userListToJson(UserList data) => json.encode(data.toJson());

class UserList {
  String firstName;
  String lastName;
  String city;
  String contactNumber;

  UserList({
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.contactNumber,
  });

  UserList copyWith({
    String? firstName,
    String? lastName,
    String? city,
    String? contactNumber,
  }) =>
      UserList(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        city: city ?? this.city,
        contactNumber: contactNumber ?? this.contactNumber,
      );

  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
        firstName: json["first_name"],
        lastName: json["last_name"],
        city: json["city"],
        contactNumber: json["contact_number"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "city": city,
        "contact_number": contactNumber,
      };
}
