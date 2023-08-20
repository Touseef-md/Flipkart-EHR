import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipkart_ehr/provider/eth_utils_provider.dart';
import 'package:flipkart_ehr/provider/filemanagement_provider.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipkart_ehr/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SendRecordScreen extends ConsumerStatefulWidget {
  static const routeName = '/send_record';
  const SendRecordScreen({super.key});

  @override
  ConsumerState<SendRecordScreen> createState() => _SendRecordScreenState();
}

class _SendRecordScreenState extends ConsumerState<SendRecordScreen> {
  void initState() {
    super.initState();
    getRequests();
  }

  List requests = [];

  Future getRequests() async {
    final consentList = (await ref
        .read(filemanagementNotifierProvider.notifier)
        .getFilesFromDirectory('/giveRecord')) as List<Future<dynamic>>?;
    requests = [];
    if (consentList != null)
      for (int i = 0; i < consentList.length; i++) {
        consentList[i].then((value) {
          setState(() {
            requests.add(value);
          });
        });
      }
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
        body: json.encode(
          {
            'priority': 'high',
            'data': dataPayload,
            'notification': <String, dynamic>{
              'title': title,
              'body': body,
              'android_channel_id': '2'
            },
            'to': token
          },
        ),
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
          'Send Records',
        ),
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            // if (appointments[index].toString() != 'null')
            return Column(
              children: [
                Card(
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text((requests[index]).toString())),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        // ref.read(ethUtilsNotifierProvider.notifier).approveConsent(hiuAddr)
                        return ref.watch(filemanagementNotifierProvider).when(
                          data: (data) {
                            return ElevatedButton(
                              onPressed: () async {
                                // print((consents[index]).runtimeType);
                                // print((consents[index])['hiuAddress']);

                                // if (await ref
                                //         .read(ethUtilsNotifierProvider.notifier)
                                //         .approveConsent(
                                //             requests[index]['hiuAddress']) ==
                                //     false)
                                // {
                                // ScaffoldMessenger.of(context)
                                //     .clearSnackBars();
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //     content: Text(
                                //       'Consent Not given',
                                //     ),
                                //   ),
                                // );
                                // } else {
                                // await ref
                                //     .read(filemanagementNotifierProvider
                                //         .notifier)
                                //     .addFileExternalStorageDirectories(
                                //         '/revokeConsent/${requests[index]['hiuAddress']}.txt',
                                //         json.encode(requests[index]));
                                String token = await getToken(
                                    (requests[index]['hiuAddress'] as String)
                                        .toLowerCase());
                                print(
                                    'THis is the path:${(await getExternalStorageDirectories())![0].path}/record/${(requests[index]['patientAddress'] as String).toLowerCase()}.txt');
                                String? record = await ref
                                    .read(
                                        filemanagementNotifierProvider.notifier)
                                    .getFile(
                                        '${(await getExternalStorageDirectories())![0].path}/record/${(requests[index]['patientAddress'] as String).toLowerCase()}.txt');
                                if (record == null) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'No records found',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                final dataPayload = {
                                  'click_action': 'FLUTTER_NOTIFICATIOIN_CLICK',
                                  'status': 'done',
                                  'body': 'This is the data body',
                                  'title': 'This is the data title',
                                  // 'address': _controller1Value,
                                  'request_no': 4,
                                  'hiuAddress': requests[index]['hiuAddress'],
                                  'record': record,
                                  'patientAddress': requests[index]
                                      ['patientAddress'],
                                  // 'name': ref
                                  //     .read(hiuNotifierProvider.notifier)
                                  //     .hiu
                                  //     .name,
                                  // 'date': selectedDate.toIso8601String(),
                                  // 'hour': selectedTime.hour,
                                  // 'minute': selectedTime.minute,
                                  // {
                                  //   'hour': selectedTime.hour,
                                  //   'minute': selectedTime.minute,
                                  // }.toString(),
                                };
                                pushMessage(token, 'Requested data sent',
                                    'Requested data sent', dataPayload);
                                // await ref
                                //     .read(
                                //         filemanagementNotifierProvider.notifier)
                                //     .deleteFileExternalStorageDirectories(
                                //         '/giveRecord/${requests[index]['hiuAddress'].toLowerCase()}.txt');
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Sent',
                                    ),
                                  ),
                                );
                                // }
                                // print('THis is the object:${json.decode(consents[index])}');
                                // _approve = true;
                                // approveOrReject(appointments[index]);
                              },
                              child: Text('Approve'),
                            );
                          },
                          error: (error, stackTrace) {
                            return Text('OOps! Something went wrong');
                          },
                          loading: () {
                            return CircularProgressIndicator();
                          },
                        );
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await ref
                            .read(filemanagementNotifierProvider.notifier)
                            .deleteFileExternalStorageDirectories(
                                '/giveRecord/${requests[index]['hiuAddress'].toLowerCase()}.txt');
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Removed',
                            ),
                          ),
                        );
                        // _approve = false;
                        // approveOrReject(appointments[index]);
                      },
                      child: Text('Reject'),
                    )
                  ],
                )
              ],
            );
            return null;
          },
          itemCount: requests.length,
        ),
      ),
    );
  }
}
