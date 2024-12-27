import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/models/orders_model.dart';
import 'package:shop_owner_app/core/models/user_model.dart';
import 'package:shop_owner_app/core/view_models/orders_provider.dart';
import 'package:shop_owner_app/ui/constants/app_consntants.dart';

import '../routes/route_name.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Provider.of<OrdersProvider>(context).ordersWithUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No orders available.'),
            );
          }

          final ordersWithUsers = snapshot.data!;
          // Filter and sort orders
          final List<Map<String, dynamic>> nonCustomerConfirmedOrders =
              ordersWithUsers
                  .where(
                      (order) => order['order'].status != 'confirmedByCustomer')
                  .toList()
                ..sort((a, b) {
                  DateTime dateA = DateTime.parse(a['order'].createdAt);
                  DateTime dateB = DateTime.parse(b['order'].createdAt);
                  return dateA.compareTo(dateB);
                });

          final List<Map<String, dynamic>> customerConfirmedOrders =
              ordersWithUsers
                  .where(
                      (order) => order['order'].status == 'confirmedByCustomer')
                  .toList();

          var orders = [
            ...nonCustomerConfirmedOrders,
            ...customerConfirmedOrders,
          ];

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderDataWithUser = orders[index];
              final OrdersModel order = orderDataWithUser['order'];
              final UserModel userData = orderDataWithUser['user'];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14, bottom: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    RouteName.userDetailsScreen,
                                    arguments: {'user': userData},
                                  );
                                },
                                child: Row(
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
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Text("Order Status:",
                                      style: TextStyle(fontSize: 16)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  DropdownButton<String>(
                                    value: order.status,
                                    items: <String>[
                                      'Pending',
                                      'Received',
                                      'Confirmed',
                                      'Delivered',
                                      if (order.status == 'confirmedByCustomer')
                                        'confirmedByCustomer',
                                    ].map((String value) {
                                      String displayValue = value == 'Confirmed'
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
                                                  fireStore =
                                                  FirebaseFirestore.instance;

                                              try {
                                                await fireStore
                                                    .collection('orders')
                                                    .doc(order.orderId)
                                                    .update({
                                                  'status': newValue,
                                                  'updatedAt': DateTime.now()
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
                              Text("Total amount: \$${order.totalAmount}",
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(
                                height: 10,
                              ),
                              iconAndText(
                                icon: Icons.calendar_month_outlined,
                                text: order.createdAt.formattedDate(),
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              iconAndText(
                                icon: Icons.phone_android,
                                text: userData.phoneNumber,
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              iconAndText(
                                icon: mShippingAddress,
                                text: userData.address,
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              ListView.builder(
                                  itemCount: order.products.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final prod = order.products[index];
                                    return Column(
                                      children: [
                                        const Divider(),
                                        ordersDetails(
                                          '${index + 1}. ${prod.productName}'
                                              .truncate(20),
                                          '(${prod.quantity.toString()})',
                                        ),
                                      ],
                                    );
                                  }),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Row iconAndText({required String text, required IconData icon}) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(
          width: 4,
        ),
        Text(
          text.truncate(45),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
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

Widget ordersDetails(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const Spacer(),
        Text(
          'Total Items: $value',
          textAlign: TextAlign.right,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    ),
  );
}
