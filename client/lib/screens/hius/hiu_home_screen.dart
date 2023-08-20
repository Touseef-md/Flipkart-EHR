import 'dart:convert';
import 'package:flipkart_ehr/provider/hiu_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipkart_ehr/provider/account_keys_provider.dart';
import 'package:flipkart_ehr/provider/eth_utils_provider.dart';
import 'package:flipkart_ehr/widgets/drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class HIUHomeScreen extends StatefulWidget {
  static const routeName = 'hiu_home';
  const HIUHomeScreen({super.key});

  @override
  State<HIUHomeScreen> createState() => _HIUHomeScreenState();
}

class _HIUHomeScreenState extends State<HIUHomeScreen> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();

  String _controller1Value = '';
  String _controller2Value = '';

  @override
  void initState() {
    // TODO: implement initState
    _controller1.addListener(() {
      setState(() {
        _controller1Value = _controller1.text;
      });
    });
    _controller2.addListener(() {
      setState(() {
        _controller2Value = _controller2.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller1.dispose();
    super.dispose();
  }

  Future getToken(String targetAddr) async {
    print('target addr:${targetAddr}');
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(targetAddr.toLowerCase())
        .get();
    print('Thisis snap:${snap}');
    String token = (snap.data() as Map)['token'];
    print('Token is ${token}');
    return token;
  }

  Future pushMessage(
      String token, String body, String title, Map dataPayload) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=${dotenv.env['FIREBASE_SERVER_KEY']}'
        },
        body: json.encode({
          'priority': 'high',
          'data': dataPayload,
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
            'android_channel_id': '2'
          },
          'to': token
        }),

        // jsonEncode(
        // <String, dynamic>{
        //   'priority': 'high',
        //   'data': dataPayload,
        //   'notification': <String, dynamic>{
        //     'title': title,
        //     'body': body,
        //     'android_channel_id': '2'
        //   },
        //   'to': token
        // },
        // ),
      );
      print('Response is ${response}');
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
        ),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
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
            Text(
              'HIU: Get Patient Records',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
            ),
            Text(
              'Check/Ask consent',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  // color: Theme.of(context).colorScheme.primary,
                  ),
              // textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              child: TextField(
                controller: _controller1,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Enter Ethereum Account Address',
                  hintStyle: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                final hasConsent = ref.read(ethUtilsNotifierProvider.notifier);
                return ElevatedButton(
                  onPressed: (_controller1Value == null ||
                          _controller1Value.isEmpty)
                      ? null
                      : () async {
                          final result =
                              await hasConsent.hasConsent(_controller1Value);
                          if (result) {
                            print('Has Consent... ');
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(
                                  seconds: 2,
                                ),
                                content: Text(
                                  'Has Consent',
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(
                                  seconds: 2,
                                ),
                                content: Text(
                                  'Does not have Consent',
                                ),
                              ),
                            );
                            print('Does not have Consent');
                            String token = await getToken(_controller1Value);
                            final dataPayload = {
                              'click_action': 'FLUTTER_NOTIFICATIOIN_CLICK',
                              'status': 'done',
                              'body': 'This is the data body',
                              'title': 'This is the data title',
                              'address': _controller1Value,
                              'request_no': 1,
                              'hiuAddress': ref.read(AccountAddressProvider),
                              'name': ref
                                  .read(hiuNotifierProvider.notifier)
                                  .hiu
                                  .name,
                              // 'date': selectedDate.toIso8601String(),
                              // 'hour': selectedTime.hour,
                              // 'minute': selectedTime.minute,
                              // {
                              //   'hour': selectedTime.hour,
                              //   'minute': selectedTime.minute,
                              // }.toString(),
                            };
                            pushMessage(
                                token,
                                '${ref.read(hiuNotifierProvider.notifier).hiu.name} wants to access your Health Records',
                                'A New HIU wants access',
                                dataPayload);
                          }
                          _controller1Value = "";
                        },
                  child: Text(
                    'Submit',
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              child: TextField(
                controller: _controller2,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Enter Ethereum Account Address',
                  hintStyle: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                final ethNotifier = ref.read(ethUtilsNotifierProvider.notifier);
                return ElevatedButton(
                  onPressed: (_controller2Value == null ||
                          _controller2Value.isEmpty)
                      ? null
                      : () async {
                          final result = await ethNotifier
                              .requestRecords(_controller2Value);
                          if (result != null) {
                            print('THis is it;');
                            // print(result[0].hex);
                            String token;
                            for (int i = 0; i < result.length; i++) {
                              token = await getToken(result[i].hex.toString());
                              final dataPayload = {
                                'click_action': 'FLUTTER_NOTIFICATIOIN_CLICK',
                                'status': 'done',
                                'body': 'This is the data body',
                                'title': 'This is the data title',
                                // 'address': _controller1Value,
                                'request_no': 3,
                                'hiuAddress': ref.read(AccountAddressProvider),
                                'name': ref
                                    .read(hiuNotifierProvider.notifier)
                                    .hiu
                                    .name,
                                'hipAddress': result[i].hex,
                                'patientAddress': _controller2Value.toLowerCase(),
                                // 'date': selectedDate.toIso8601String(),
                                // 'hour': selectedTime.hour,
                                // 'minute': selectedTime.minute,
                                // {
                                //   'hour': selectedTime.hour,
                                //   'minute': selectedTime.minute,
                                // }.toString(),
                              };
                              print('BEfore push message');
                              pushMessage(
                                  token,
                                  '${ref.read(hiuNotifierProvider.notifier).hiu.name} wants to access records',
                                  'A HIU wants to access records',
                                  dataPayload);
                            }
                          }
                          // await hasConsent.hasConsent(_controller2Value);
                          // if (result) {
                          //6265093937@ybi
                          // print('Has Consent... ');
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(
                                seconds: 2,
                              ),
                              content: Text(
                                'Requested',
                              ),
                            ),
                          );
                          // }
                          // } else {
                          //   ScaffoldMessenger.of(context).clearSnackBars();
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       duration: Duration(
                          //         seconds: 2,
                          //       ),
                          //       content: Text(
                          //         'Does not have Consent',
                          //       ),
                          //     ),
                          //   );
                          //   print('Does not have Consent');
                          //   String token = await getToken(_controller2Value);
                          //   final dataPayload = {
                          //     'click_action': 'FLUTTER_NOTIFICATIOIN_CLICK',
                          //     'status': 'done',
                          //     'body': 'This is the data body',
                          //     'title': 'This is the data title',
                          //     'address': _controller2Value,
                          //     'request_no': 1,
                          //     'hiuAddress': ref.read(AccountAddressProvider),
                          //     'name':
                          //         ref.read(hiuNotifierProvider.notifier).hiu.name,
                          //     // 'date': selectedDate.toIso8601String(),
                          //     // 'hour': selectedTime.hour,
                          //     // 'minute': selectedTime.minute,
                          //     // {
                          //     //   'hour': selectedTime.hour,
                          //     //   'minute': selectedTime.minute,
                          //     // }.toString(),
                          //   };
                          //   pushMessage(
                          //       token,
                          //       '${ref.read(hiuNotifierProvider.notifier).hiu.name} wants to access your Health Records',
                          //       'A New HIU wants access',
                          //       dataPayload);
                          // }
                          _controller2.text = "";
                          // _controller2Value = "";
                        },
                  child: Text(
                    'Request Records',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
