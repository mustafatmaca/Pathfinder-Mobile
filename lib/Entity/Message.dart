import 'package:pathfinder/Entity/User.dart';

class Message {
  final String id;
  final dynamic sender;
  final dynamic toUser;
  final String context;

  const Message({
    required this.id,
    required this.sender,
    required this.toUser,
    required this.context,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      sender: json['sender'],
      toUser: json['toUser'],
      context: json['context'],
    );
  }
}
