import 'package:pathfinder/Entity/City.dart';

class User {
  final String? id;
  final String? mail;
  final String? password;
  final String? name;
  final String? gsm;
  final String? role;
  final dynamic city;
  final List<dynamic>? messages;

  const User({
    required this.id,
    required this.mail,
    required this.password,
    required this.name,
    required this.gsm,
    required this.role,
    required this.city,
    required this.messages,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      mail: json['mail'],
      password: json['password'],
      name: json['name'],
      gsm: json['gsm'],
      role: json['role'],
      city: json['city'],
      messages: json['messages'],
    );
  }
}
