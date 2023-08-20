import 'package:flipkart_ehr/provider/account_keys_provider.dart';
import 'package:flipkart_ehr/screens/hips/hip_home_screen.dart';
import 'package:flipkart_ehr/screens/hips/records_screen.dart';
import 'package:flipkart_ehr/screens/hips/send_record_screen.dart';
import 'package:flipkart_ehr/screens/hius/hiu_home_screen.dart';
import 'package:flipkart_ehr/screens/patient/approve_consent_screen.dart';
import 'package:flipkart_ehr/screens/patient/patient_home_screen.dart';
import 'package:flipkart_ehr/screens/patient/revoke_consent.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipkart_ehr/screens/home_screen.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                if (ref.read(entityProvider) == 1) {
                  Navigator.pushReplacementNamed(
                    context,
                    PatientHomeScreen.routeName,
                  );
                } else if (ref.read(entityProvider) == 2) {
                  Navigator.pushReplacementNamed(
                    context,
                    HIPHomeScreen.routeName,
                  );
                } else if (ref.read(entityProvider) == 3) {
                  Navigator.pushReplacementNamed(
                    context,
                    HIUHomeScreen.routeName,
                  );
                } else
                  Navigator.pushReplacementNamed(
                    context,
                    HomeScreen.routeName,
                  );
              },
            ),
            if (ref.read(entityProvider) == 1) ...[
              ListTile(
                leading: Icon(
                  Icons.check,
                ),
                title: Text('Approve Consent'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    ApproveConsentScreen.routeName,
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.block,
                ),
                title: Text('Revoke Consent'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    RevokeConsent.routeName,
                  );
                },
              ),
            ],
            if (ref.read(entityProvider) == 2) ...[
              ListTile(
                leading: Icon(
                  Icons.receipt_rounded,
                ),
                title: Text('Records'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    RecordsScreen.routeName,
                  );
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.send,
                ),
                title: Text('Send Records'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    SendRecordScreen.routeName,
                  );
                },
              ),
            ],
            if (ref.read(entityProvider) == 3) ...[
              ListTile(
                leading: Icon(
                  Icons.send,
                ),
                title: Text('Requested Records'),
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    SendRecordScreen.routeName,
                  );
                },
              ),
            ]
          ],
        ),
      ),
    );
  }
}
