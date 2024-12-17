import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shop_owner_app/core/models/orders_model.dart';
import 'package:shop_owner_app/ui/routes/route_name.dart';
import 'package:sizer/sizer.dart';
import '../../core/models/customer_model.dart';
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
    final orders = Provider.of<List<OrdersModel>>(context);
    final isLoading = orders.length == 1 && orders.first.orderId.isEmpty;

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
                    final order = orders[index];

                    return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            RouteName.userDetailsScreen,
                            arguments: {
                              'user': CustomerModel(name: 'fff'),
                            },
                          );
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child:
                                        Text(order.createdAt.formattedDate()),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  const Divider(
                                    height: 4,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          //TODO will implement order details here..
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              '${index + 1}: ',
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                            const Icon(
                                              Icons.person,
                                              color: Colors.blue,
                                              size: 26,
                                            ),
                                            const Text(
                                              "Mr. Andrew",
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Text("Order Status:",
                                          style: TextStyle(fontSize: 16)),
                                      DropdownButton<String>(
                                        value: order.status,
                                        items: <String>[
                                          //TODO Removing confirmed by customer for the admin app..
                                          'Pending',
                                          'Received',
                                          'Confirmed',
                                          'Delivered',
                                          'confirmedByCustomer'
                                        ].map((String value) {
                                          String showCaseValue = value == 'Confirmed'? 'On the way':value;
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(showCaseValue),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) async {
                                          final FirebaseFirestore _fireStore =
                                              FirebaseFirestore.instance;

                                          try {
                                            await _fireStore
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
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.phone_android),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text("01***********"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const Row(
                                    children: [
                                      Icon(mShippingAddress),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                          "47RM+9FH Dubai - United Arab Emirates"),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 2,
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
                                              prod.productName.truncate(30),
                                            ),
                                            Text(
                                                '(${prod.quantity.toString()})')
                                          ],
                                        );
                                      }),
                                ],
                              ),
                            ),
                            Gap(2.h),
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
