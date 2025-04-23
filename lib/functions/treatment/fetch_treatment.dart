import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/treatment_record_model.dart';

Stream<List<TreatmentRecord>> fetchTreatmentRecords() {
  return FirebaseFirestore.instance.collection('treatment').snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => TreatmentRecord.fromFirestore(doc))
          .toList()
          .cast<TreatmentRecord>());
}
