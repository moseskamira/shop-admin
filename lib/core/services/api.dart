import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_owner_app/core/models/product_model.dart';

class Api{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;
  late CollectionReference ref;

  Api({required this.path}) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.get();
  }
  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots() ;
  }
  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }
  Future<void> removeDocument(String id){
    return ref.doc(id).delete();
  }
  Future<void> addDocument({ required ProductModel productModel}) {
     return ref.doc(productModel.id).set(productModel.toJson());
  }
  Future<void> updateDocument(Map<String,dynamic> data , String id) {
    return ref.doc(id).update(data);
  }


}