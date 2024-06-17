Flutter Frontend

Set-up Guidelines


1. Clone the repository using terminal:
           git clone https://github.com/danielwambo/Frontend-Invoice.git


                cd Frontend-Invoice



3. Install dependencies:

                flutter pub get



4. Set up ApiService.dart:

 Update baseUrl in services/api_service.dart to match your Laravel backend URL (http://localhost:8000/api).



4. Run the Flutter app:

                flutter run



Usage

Creating Invoices: Use the Flutter app to create new invoices with descriptions and amounts.

Initiating Payments: Initiate payments for invoices directly from the Flutter app.

Viewing Transactions: View transaction histories both in the Laravel backend (via API endpoints) and in the Flutter app.
