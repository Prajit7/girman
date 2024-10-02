import 'dart:convert';

class UserModel {
  String city;
  String contactNumber;
  String firstName;
  String lastName;

  UserModel({
    required this.city,
    required this.contactNumber,
    required this.firstName,
    required this.lastName,
  });

  UserModel copyWith({
    String? city,
    String? contactNumber,
    String? firstName,
    String? lastName,
  }) {
    return UserModel(
      city: city ?? this.city,
      contactNumber: contactNumber ?? this.contactNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'city': city,
      'contact_number': contactNumber,
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      city: map['city'] as String,
      contactNumber: map['contact_number'] as String,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(city: $city, contact_number: $contactNumber, first_name: $firstName, last_name: $lastName)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.city == city &&
        other.contactNumber == contactNumber &&
        other.firstName == firstName &&
        other.lastName == lastName;
  }

  @override
  int get hashCode {
    return city.hashCode ^
        contactNumber.hashCode ^
        firstName.hashCode ^
        lastName.hashCode;
  }
}
