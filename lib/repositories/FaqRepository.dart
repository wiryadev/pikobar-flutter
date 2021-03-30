import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FaqRepository {
  final firestore = FirebaseFirestore.instance;

  Stream<List<DocumentSnapshot>> getFaq(
      {@required String faqCollection, String category}) {
   final Query faqQuery = firestore
        .collection(faqCollection)
        .where("category", isEqualTo: category);

    return faqQuery.snapshots().map(
        (QuerySnapshot snapshot) => snapshot.docs.map((doc) => doc).toList());
  }
}