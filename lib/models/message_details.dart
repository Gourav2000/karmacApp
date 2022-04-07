class MessageDetails {
  final String author;
  final String id;
  final String text;
  final DateTime createdAt;
  final bool isRead;
  final String type;

  MessageDetails({
    required this.id,
    required this.author,
    required this.createdAt,
    required this.text,
    required this.isRead,
    required this.type,
  });
}
