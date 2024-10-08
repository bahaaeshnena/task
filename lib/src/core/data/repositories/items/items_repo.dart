import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task/src/features/home/models/item_model.dart';

class ItemsRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'items';

  Future<QuerySnapshot> getItemsByName(String name) async {
    try {
      return await _firestore
          .collection(_collectionPath)
          .where('name', isEqualTo: name)
          .get();
    } catch (e) {
      log('Error fetching tables by name: $e');
      rethrow;
    }
  }

  Stream<List<ItemModel>> streamItems() {
    return _firestore.collection(_collectionPath).snapshots().map((snapshot) {
      List<ItemModel> items = snapshot.docs.map((doc) {
        return ItemModel.fromMap(doc.data());
      }).toList();

      items.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

      return items;
    });
  }

  Future<List<ItemModel>> getItems() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(_collectionPath).get();
      return querySnapshot.docs.map((doc) {
        return ItemModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> addItem(ItemModel item) async {
    try {
      await _firestore.collection(_collectionPath).add(item.toMap());
    } catch (e) {
      log('Error adding table: $e');
    }
  }

  //delete item
  Future<void> deleteItem(String id) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('id', isEqualTo: id)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      log('Error deleting table: $e');
    }
  }
}
