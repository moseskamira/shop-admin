import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/models/user_model.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
 import '../constants/app_consntants.dart';
import 'package:intl/intl.dart';

class PendingOrdersList extends StatefulWidget {
  const PendingOrdersList({super.key});

  @override
  State<PendingOrdersList> createState() => _PendingOrdersListState();
}

class _PendingOrdersListState extends State<PendingOrdersList> {
  @override
  Widget build(BuildContext context) {
    var orders = context.watch<List<Map<String, dynamic>>>();
    final users = context.watch<List<UserModel>>();
    final isLoading = orders.length == 1 && orders.first['order'].orderId == '';

    // Filter and sort orders
    final List<Map<String, dynamic>> nonCustomerConfirmedOrders = orders
        .where((order) => order['order'].status != 'confirmedByCustomer')
        .toList()
      ..sort((a, b) {
        DateTime dateA = DateTime.parse(a['order'].createdAt);
        DateTime dateB = DateTime.parse(b['order'].createdAt);
        return dateA.compareTo(dateB);
      });

    final List<Map<String, dynamic>> customerConfirmedOrders = orders
        .where((order) => order['order'].status == 'confirmedByCustomer')
        .toList();

    orders = [
      ...nonCustomerConfirmedOrders,
      ...customerConfirmedOrders,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : orders.isEmpty
              ? const Center(
                  child: Text('No Active orders found.'),
                )
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final orderData = orders[index];
                    final userData = users.firstWhere(
                      (user) => user.id == orderData['order'].customerId,
                      orElse: () => UserModel.loading(),
                    );

                    final order = orderData['order'];
                    return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            RouteName.userDetailsScreen,
                            arguments: {
                              'user': UserModel(fullName: 'fff'),
                            },
                          );
                        },
                        child: Column(
                          children: [
                            Card(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 14, bottom: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${index + 1}. ${userData.fullName}',
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Text("Order Status:",
                                            style: TextStyle(fontSize: 16)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        DropdownButton<String>(
                                          value: order.status,
                                          items: <String>[
                                            'Pending',
                                            'Received',
                                            'Confirmed',
                                            'Delivered',
                                            if (order.status ==
                                                'confirmedByCustomer')
                                              'confirmedByCustomer',
                                          ].map((String value) {
                                            String displayValue = value ==
                                                    'Confirmed'
                                                ? 'On the way'
                                                : value == 'confirmedByCustomer'
                                                    ? 'Confirmed by Customer'
                                                    : value;

                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(displayValue),
                                            );
                                          }).toList(),
                                          onChanged: order.status ==
                                                  'confirmedByCustomer'
                                              ? null // Disable dropdown interaction for 'confirmedByCustomer'
                                              : (String? newValue) async {
                                                  if (newValue != null) {
                                                    final FirebaseFirestore
                                                        _fireStore =
                                                        FirebaseFirestore
                                                            .instance;

                                                    try {
                                                      await _fireStore
                                                          .collection('orders')
                                                          .doc(order.orderId)
                                                          .update({
                                                        'status': newValue,
                                                        'updatedAt': DateTime
                                                                .now()
                                                            .toIso8601String(),
                                                      });
                                                    } catch (e) {
                                                      rethrow;
                                                    }
                                                  }
                                                },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                      Text("Total payable amount: \$${order.totalAmount}",
                                        style: TextStyle(fontSize: 16)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                            Icons.calendar_month_outlined),
                                        Text('${order.createdAt}'
                                            .formattedDate()),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone_android),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          userData.phoneNumber,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(mShippingAddress),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(userData.address),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    ListView.builder(
                                        itemCount: order.products.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          final prod = order.products[index];
                                          return Row(
                                            children: [
                                              Text(
                                                '${index + 1}. ${prod.productName}'
                                                    .truncate(30),
                                              ),
                                              Text(
                                                  '(${prod.quantity.toString()})')
                                            ],
                                          );
                                        }),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ));
                  },
                ),
    );
  }
}

extension on String {
  String formattedDate() {
    try {
      DateTime dateTime = DateTime.parse(this);
      return DateFormat('MMMM d, y').format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
  }
}

extension on String {
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }
}
