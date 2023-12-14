import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/models/weight_entry.dart';

class WeightEntryProvider with ChangeNotifier {
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('weight_logs');

  Future<void> addWeightLog(int userWeight) async {
    await collection.add({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'userWeight': userWeight,
      'dateCreated': FieldValue.serverTimestamp(),
    });
    notifyListeners();
  }

  Future<void> updateWeightLog(WeightEntry entry) async {
    await collection.doc(entry.id).update(entry.toFirestore());
    notifyListeners();
  }

  Future<void> deleteWeightLog(String id) async {
    await collection.doc(id).delete();
    notifyListeners();
  }

  Stream<List<WeightEntry>> get userWeightLogs {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return collection.where('userId', isEqualTo: userId).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => WeightEntry.fromFirestore(doc))
            .toList());
  }
}
