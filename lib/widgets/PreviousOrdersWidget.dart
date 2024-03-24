import 'package:flutter/material.dart';

class PreviousOrdersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.grey[200],
      ),
      child: SizedBox(
        height: 300, // Set the height as needed
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          children: [
            _buildOrderItem(
              orderName: 'Pizza',
              amount: '\$20.00',
              customerName: 'John Doe',
              // Add more details as needed
            ),
            _buildOrderItem(
              orderName: 'Burger Combo',
              amount: '\$15.50',
              customerName: 'Jane Smith',
              // Add more details as needed
            ),
            _buildOrderItem(
              orderName: 'Burger Combo',
              amount: '\$15.50',
              customerName: 'Jane Smith',
              // Add more details as needed
            ),
            _buildOrderItem(
              orderName: 'Burger Combo',
              amount: '\$15.50',
              customerName: 'Jane Smith',
              // Add more details as needed
            ),
            _buildOrderItem(
              orderName: 'Burger Combo',
              amount: '\$15.50',
              customerName: 'Jane Smith',
              // Add more details as needed
            ),
            // Add more order items as needed
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem({
    required String orderName,
    required String amount,
    required String customerName,
    // Add more parameters for additional details
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order: $orderName',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          Text('Amount: $amount'),
          SizedBox(height: 5.0),
          Text('Customer Name: $customerName'),
          // Add more Text widgets for additional details
        ],
      ),
    );
  }
}
