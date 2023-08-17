import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewestListWidget extends StatefulWidget {
  const NewestListWidget({super.key});

  @override
  State<NewestListWidget> createState() => _NewestListWidgetState();
}

class _NewestListWidgetState extends State<NewestListWidget> {
  final _auth = FirebaseAuth.instance;
  // Points to the root reference
  final storage = FirebaseStorage.instance;

  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  CollectionReference _itemsCollection =
      FirebaseFirestore.instance.collection('items');
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: StreamBuilder<QuerySnapshot>(
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

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 380,
                      height: 150,
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
                            builder: (context, AsyncSnapshot<String> snapshot) {
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
                          width: 190,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                item['name'],
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              RatingBar.builder(
                                initialRating: 4,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 18,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.red,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                              Text(
                                "₹${item['price']}",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  color: Colors.red,
                                  size: 26,
                                ),
                                Icon(
                                  CupertinoIcons.cart,
                                  color: Colors.red,
                                  size: 26,
                                )
                              ]),
                        )
                      ]),
                    ),
                  );
                },
              ),
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
}
