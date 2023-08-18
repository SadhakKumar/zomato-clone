import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zomato_clone/pages/Cart.dart';

import '../pages/LoginPage.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Handle the case where the user is not signed in
      return Drawer();
    }

    return Drawer(
      child: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the document is being fetched, show a loading indicator
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            // Handle any errors that occurred while fetching the document
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            // Handle the case where the user document does not exist
            return Drawer();
          }

          if (snapshot.hasData && snapshot.data!.exists) {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            var name = userData['name'] as String;
            var email = userData['email'] as String;

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(name),
                  accountEmail: Text(email),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/woman.png',
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[300],
                    // image: DecorationImage(
                    //   image: AssetImage('assets/images/bg.jpg'),
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.account_circle_outlined),
                  title: Text('Profile'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.work),
                  title: Text('cart'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Cart()),
                    );
                  },
                ),
                SizedBox(height: 10),
                Divider(color: Colors.grey[600]),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    logout(context);
                  },
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    const CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
