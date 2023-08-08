import 'package:flipkart_ehr/screens/patient/user_verification_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryList = [
      'Patient',
      'HIP(Health Information Provider)',
      'HIU (Health Information User)'
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flipkart-EHR',
        ),
      ),
      body:
          // Center(
          //   child: Text('fdsf'),
          // ),
          Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   // mainAxisSize: MainAxisSize.values[0],
        children: [
          Card(
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(
            //     10,
            //   ),
            // ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              child: Text('Choose the one which best suites you',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          Container(
            // color: Colors.black,
            height: 150,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () {
                    if (categoryList[index] == 'Patient') {
                      Navigator.pushReplacementNamed(
                          context, UserVerificationScreen.routeName);
                    }
                    else if(categoryList[index]=='HIP(Health Information Provider)'){

                    }
                    else{
                      
                    }
                  },
                  child: Text(
                    categoryList[index],
                  ),
                  // style: Ele,
                );
              },
              itemCount: categoryList.length,
            ),
          )
        ],
      ),
    );
  }
}
