import 'package:flipkart_ehr/provider/account_keys_provider.dart';
import 'package:flipkart_ehr/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientHomeScreen extends StatelessWidget {
  static const routeName = '/patient_home';
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
        ),
      ),
      drawer: CustomDrawer(),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Consumer(
                builder: (context, ref, child) {
                  return Text(
                    textAlign: TextAlign.center,
                    'Your address:\n ${ref.read(AccountAddressProvider)}',
                  );
                },
                // child:
              ),
            ),
          ),
        ],
      ),
    );
  }
}
