import 'package:flipkart_ehr/screens/home_screen.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // var session = ref.read(sessionControl.notifier).state;
    // print('THis is the session${session}');
    return Drawer(
      // surfaceTintColor: Colors.black,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              color: Colors.grey,
            ),
            // child: C,
            ListTile(
              leading: Icon(
                Icons.home,
              ),
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  HomeScreen.routeName,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
