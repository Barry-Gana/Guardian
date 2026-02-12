enum ChatSender { user, guardian }
enum MessageType { status, alert, insight }

class ChatMessageModel {
  final String id;
  final DateTime timestamp;
  final ChatSender sender;
  final MessageType messageType;
  final String text;

  const ChatMessageModel({
    required this.id,
    required this.timestamp,
    required this.sender,
    required this.messageType,
    required this.text,
  });
}
