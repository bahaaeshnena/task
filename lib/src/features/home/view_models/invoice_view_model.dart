import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task/src/core/data/repositories/invoice/invoice_repo.dart';
import 'package:task/src/features/home/models/invoice_model.dart';
import 'package:task/src/features/home/models/item_model.dart';
import 'package:task/src/features/home/models/table_model.dart';
import 'package:uuid/uuid.dart';

import 'package:intl/intl.dart';

class InvoiceViewModel with ChangeNotifier {
  InvoiceViewModel({required InvoiceRepo invoiceRepo})
      : _invoiceRepo = invoiceRepo;

  final InvoiceRepo _invoiceRepo;
  final List<TableModel> _invoices = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<TableModel> get invoices => _invoices;
  Future<void> createInvoice(
      TableModel tableName, List<ItemModel> items, double totalPrice) async {
    String id = const Uuid().v4();
    DateTime date = DateTime.now();

    InvoiceModel newInvoice = InvoiceModel(
      id: id,
      table: TableModel(
        name: tableName.name,
        id: tableName.id,
        status: tableName.status,
        numberOfChairs: tableName.numberOfChairs,
      ),
      items: items,
      date: date,
      totalPrice: totalPrice,
    );

    try {
      await _invoiceRepo.addInvoice(newInvoice);
    } catch (e) {
      throw Exception('Failed to create invoice: $e');
    }
  }

  Future<void> deleteInvoice(String id) async {
    try {
      await _invoiceRepo.deleteInvoice(id);
      _invoices.removeWhere((table) => table.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete table';
      notifyListeners();
    }
  }

  Future<void> updateInvoicePaid(String id, bool paid) async {
    try {
      await _invoiceRepo.updateInvoice(id, paid);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update invoice paid';
      notifyListeners();
    }
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }

  Future<void> updateTableStatusToReserved(
      String tableId, String status) async {
    final querySnapshot = await _firestore
        .collection('tables')
        .where('id', isEqualTo: tableId)
        .get();
    if (querySnapshot.docs.isEmpty) {
      throw Exception('Invoice not found');
    }
    final documentId = querySnapshot.docs.first.id;

    await _firestore
        .collection('tables')
        .doc(documentId)
        .update({'status': status});
  }
}
