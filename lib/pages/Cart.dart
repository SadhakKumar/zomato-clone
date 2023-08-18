import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/AppbarWidget.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final _auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection('items');

  Map<dynamic, int> cart = {};
  num total = 0;
  Razorpay? _razorpay;
  StreamController<Map<dynamic, int>> cartStreamController =
      StreamController<Map<dynamic, int>>();

  @override
  void initState() {
    getCart();
    super.initState();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    getTotalAmount();
    context;
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    cart.clear();
    cartStreamController.add(cart);
    deleteCart();
    Fluttertoast.showToast(
        msg: "SUCCESS PAYMENT: ${response.paymentId}", timeInSecForIosWeb: 4);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR HERE: ${response.code} - ${response.message}",
        timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET IS : ${response.walletName}",
        timeInSecForIosWeb: 4);
  }

  void openPaymentPortal(double amount) async {
    var options = {
      'key': 'rzp_test_juCmOKhl8Noq5l',
      'amount': amount * 100,
      'name': 'sadhak',
      'description': 'Payment',
      'prefill': {'contact': '9999999999', 'email': 'jhon@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cart",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _itemsCollection.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var item = snapshot.data!.docs[index];

                  total += item['price'];

                  Future<Map<dynamic, int>> cartItems = getCartItems();

                  return FutureBuilder(
                    future: cartItems,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        Map<dynamic, int> cartItem = snapshot.data!;

                        if (cartItem.containsKey(item.id)) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Container(
                              width: 340,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(children: [
                                InkWell(
                                  onTap: () {},
                                  child: FutureBuilder(
                                    future: downloadURL(item['url']),
                                    builder: (context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.hasData) {
                                        return Container(
                                          alignment: Alignment.center,
                                          child: Image.network(snapshot.data!,
                                              height: 120,
                                              width: 120,
                                              fit: BoxFit.fill),
                                        );
                                      }
                                      if (snapshot.connectionState ==
                                              ConnectionState.waiting ||
                                          !snapshot.hasData) {
                                        return CircularProgressIndicator();
                                      }
                                      return Container();
                                    },
                                  ),
                                ),
                                Container(
                                  width: 180,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        item['title'],
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "₹${item['price']}",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              cart.update(
                                                  item.id, (value) => ++value,
                                                  ifAbsent: () => 1);
                                            });
                                          },
                                          child: Icon(
                                            CupertinoIcons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "${cart[item.id]}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (cart[item.id]! <= 1) {
                                              print('cant go below 1');
                                            } else {
                                              setState(() {
                                                cart.update(
                                                    item.id, (value) => --value,
                                                    ifAbsent: () => 1);
                                              });
                                            }
                                          },
                                          child: Icon(
                                            CupertinoIcons.minus,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      }
                    },
                  );
                },
              ),
            );
          }),
      bottomNavigationBar: StreamBuilder<Map<dynamic, int>>(
          stream: cartStreamController.stream,
          builder: (context, snapshot) {
            return FutureBuilder<double>(
              future: calculateTotalPrice(snapshot.data!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return BottomAppBar(
                    child: SizedBox.shrink(),
                  );
                }
                return BottomAppBar(
                  child: Container(
                    height: 56,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: \₹${snapshot.data}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            openPaymentPortal(snapshot.data!);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 32), // Adjust padding as needed
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Adjust border radius as needed
                            ),
                            primary: Color.fromARGB(255, 255, 110,
                                32), // Change the background color
                          ),
                          child: Text(
                            'Place Order',
                            style: TextStyle(
                                fontSize: 18,
                                color:
                                    Colors.white), // Adjust font size as needed
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  Future<String> downloadURL(String imageURL) async {
    try {
      Reference ref = FirebaseStorage.instance.ref();
      String downloadUrl = await ref.child(imageURL).getDownloadURL();
      print("Download URL: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("Error fetching URL: $e");
      return ""; // Return an empty string or handle the error appropriately
    }
  }

  Future<Map<dynamic, int>> getCartItems() async {
    var user = _auth.currentUser;
    DocumentSnapshot userSnapshot = await _userCollection.doc(user!.uid).get();
    List<dynamic> array = userSnapshot['cart'];

    Map<dynamic, int> count = {};
    array.forEach((i) => count[i] = (count[i] ?? 0) + 1);
    cartStreamController.add(cart);
    return count;
  }

  getCart() async {
    var user = _auth.currentUser;
    DocumentSnapshot userSnapshot = await _userCollection.doc(user!.uid).get();
    List<dynamic> array = userSnapshot['cart'];

    Map<dynamic, int> count = {};
    array.forEach((i) => count[i] = (count[i] ?? 0) + 1);
    cart = count;
    cartStreamController.add(cart);
  }

  Future<double> getTotalPrice() async {
    double total = 0;
    for (var entry in cart.entries) {
      print(entry);
      DocumentSnapshot itemSnapshot =
          await _itemsCollection.doc(entry.key).get();
      total += itemSnapshot['price'] * entry.value;
    }
    cartStreamController.add(cart);
    return total;
  }

  deleteCart() async {
    var user = _auth.currentUser;
    DocumentSnapshot userSnapshot = await _userCollection.doc(user!.uid).get();
    List<dynamic> array = userSnapshot['cart'];
    array.removeRange(0, array.length);
    userSnapshot.reference.update({'cart': array});
  }

  getTotalAmount() async {
    for (var entry in cart.entries) {
      print(entry);
      DocumentSnapshot itemSnapshot =
          await _itemsCollection.doc(entry.key).get();
      total += itemSnapshot['price'] * entry.value;
    }
    cartStreamController.add(cart);
  }

  Future<double> calculateTotalPrice(Map<dynamic, int> cartMap) async {
    double total = 0.0;
    for (var entry in cartMap.entries) {
      DocumentSnapshot itemSnapshot =
          await _itemsCollection.doc(entry.key).get();
      total += itemSnapshot['price'] * entry.value;
    }
    return total;
  }
}
