import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class ReceipeRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('receipe');

  //get all receipe
  Stream<List<Recipe>> receipe() {
    return _collection.orderBy('name').snapshots().map((snapshot) => snapshot
        .docs
        .map((doc) => Recipe.fromMap(doc as Map<String, dynamic>))
        .toList());
  }

  //add receipe
  Future<void> addReceipe(Recipe receipe) {
    return _collection.add(receipe.toMap());
  }

  //update receipe
  Future<void> updateRecipe(String id, Recipe receipe) {
    return _collection.doc(receipe.Title).update(receipe.toMap());
  }

  //delete receipe
  Future<void> deleteReceipe(String receipeId) {
    return _collection.doc(receipeId).delete();
  }
}
