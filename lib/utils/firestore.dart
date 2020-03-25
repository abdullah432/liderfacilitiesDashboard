import 'package:cloud_firestore/cloud_firestore.dart';

class CustomFirestore {
  static getAllUserData() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("users").getDocuments();
    var list = querySnapshot.documents;
    return list;
  }

  static getAllTaskerData() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("users")
        .where('istasker', isEqualTo: true)
        .getDocuments();
    var list = querySnapshot.documents;
    return list;
  }

  static getAllBookingData() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("book").getDocuments();
    var list = querySnapshot.documents;
    return list;
  }

  static getAllTransactionValue() async{
     Firestore.instance
        .collection('book')
        .snapshots()
        .listen((snapshot) {
      double tempTotal = snapshot.documents.fold(0, (tot, doc) => tot + double.parse(doc.data['price']));
      print('transaction: '+tempTotal.toString());
      return tempTotal;
    });

  }
}
