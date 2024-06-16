import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Method to fetch invoices
  static Future<List<dynamic>> getInvoices() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/invoices'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load invoices');
      }
    } catch (e) {
      throw Exception('Failed to load invoices: $e');
    }
  }

  // Method to create an invoice
  static Future<Map<String, dynamic>> createInvoice(String description, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/invoices'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'description': description,
          'amount': amount,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create invoice');
      }
    } catch (e) {
      throw Exception('Failed to create invoice: $e');
    }
  }



  // Method to fetch transactions
  static Future<List<dynamic>> getTransactions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/transactions'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }
// Method to initiate payment for an invoice
  static Future<Map<String, dynamic>> initiatePayment(int invoiceId, String phone) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/invoices/$invoiceId/payment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'phone': '254$phone', // Adjust this based on your backend requirements
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to initiate payment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to initiate payment: $e');
    }
  }



}
