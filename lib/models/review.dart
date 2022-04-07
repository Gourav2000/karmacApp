import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final double rating;
  final String service;
  final String desc;
  final String name;
  final String image;
  final String uid;
  final int likes;
  final int dislikes;
  final Timestamp date;
  final String title;
  final String orderId;

  Review({
    required this.id,
    required this.rating,
    required this.desc,
    required this.service,
    required this.name,
    required this.uid,
    required this.image,
    required this.likes,
    required this.dislikes,
    required this.date,
    required this.title,
    required this.orderId,
  });
}
