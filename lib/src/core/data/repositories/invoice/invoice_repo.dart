import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task/src/features/home/models/invoice_model.dart';

class InvoiceRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'invoices';

  Future<void> addInvoice(InvoiceModel invoice) async {
    try {
      await _firestore.collection(_collectionPath).add(invoice.toMap());
    } catch (e) {
      throw Exception('Failed to add invoice: $e');
    }
  }

  Future<List<InvoiceModel>> getInvoices() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(_collectionPath).get();
      return snapshot.docs.map((doc) {
        return InvoiceModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch invoices: $e');
    }
  }

  Future<void> updateInvoice(String invoiceId, bool paid) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('id', isEqualTo: invoiceId)
          .get();
      if (querySnapshot.docs.isEmpty) {
        throw Exception('Invoice not found');
      }
      final documentId = querySnapshot.docs.first.id;

      await _firestore
          .collection(_collectionPath)
          .doc(documentId)
          .update({'paid': paid});
    } catch (e) {
      throw Exception('Failed to update invoice: $e');
    }
  }

  Future<void> deleteInvoice(String invoiceId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .where('id', isEqualTo: invoiceId)
          .get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete invoice: $e');
    }
  }
}
