import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'transaction_list_page.dart'; // Import the transaction list page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoice System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InvoiceListPage(),
    );
  }
}

class InvoiceListPage extends StatefulWidget {
  @override
  _InvoiceListPageState createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  late Future<List<dynamic>> _invoices;

  @override
  void initState() {
    super.initState();
    _invoices = ApiService.getInvoices();
  }

  void _showCreateInvoiceDialog() {
    final _descriptionController = TextEditingController();
    final _amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create Invoice'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final description = _descriptionController.text;
                final amount = double.parse(_amountController.text);
                ApiService.createInvoice(description, amount).then((invoice) {
                  setState(() {
                    _invoices = ApiService.getInvoices();
                  });
                  Navigator.of(context).pop();
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to create invoice: $error')),
                  );
                });
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _initiatePayment(int invoiceId) {
    final _phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Initiate Payment'),
          content: TextField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: 'Phone Number'),
            keyboardType: TextInputType.phone,
          ),
          actions: [
            TextButton(
              onPressed: () {
                final phone = _phoneController.text;
                ApiService.initiatePayment(invoiceId, phone).then((response) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Payment Initiated')),
                  );
                  Navigator.of(context).pop();
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to initiate payment: $error')),
                  );
                  Navigator.of(context).pop();
                });
              },
              child: Text('Pay'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoices'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransactionListPage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _invoices,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final invoices = snapshot.data!;
            return ListView.builder(
              itemCount: invoices.length,
              itemBuilder: (context, index) {
                final invoice = invoices[index];
                return ListTile(
                  title: Text(invoice['description']),
                  subtitle: Text('Amount: ${invoice['amount']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.payment),
                    onPressed: () {
                      _initiatePayment(invoice['id']);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateInvoiceDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
