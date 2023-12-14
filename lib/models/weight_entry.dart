import 'package:cloud_firestore/cloud_firestore.dart';

class WeightEntry {
  String id;
  String userId;
  int userWeight;
  DateTime dateCreated;

  WeightEntry(
      {required this.id,
      required this.userId,
      required this.userWeight,
      required this.dateCreated});

  factory WeightEntry.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return WeightEntry(
      id: doc.id,
      userId: data['userId'] ?? '',
      userWeight: data['userWeight']?.toInt() ?? 0.0,
      dateCreated: (data['dateCreated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userWeight': userWeight,
      'dateCreated': dateCreated
    };
  }
}
