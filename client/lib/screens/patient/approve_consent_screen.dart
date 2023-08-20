import 'dart:convert';
import 'package:flipkart_ehr/provider/eth_utils_provider.dart';
import 'package:flipkart_ehr/provider/filemanagement_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipkart_ehr/widgets/drawer.dart';

class ApproveConsentScreen extends ConsumerStatefulWidget {
  static const routeName = '/approve_consent';

  ApproveConsentScreen({super.key});

  @override
  ConsumerState<ApproveConsentScreen> createState() =>
      _ApproveConsentScreenState();
}

class _ApproveConsentScreenState extends ConsumerState<ApproveConsentScreen> {
  @override
  void initState() {
    super.initState();
    getConsents();
  }

  List consents = [];

  Future getConsents() async {
    final consentList = (await ref
        .read(filemanagementNotifierProvider.notifier)
        .getFilesFromDirectory('/consent')) as List<Future<dynamic>>?;
    consents = [];
    if (consentList != null)
      for (int i = 0; i < consentList.length; i++) {
        consentList[i].then((value) {
          setState(() {
            consents.add(value);
          });
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Approve Consent',
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
                      child: Text((consents[index]).toString())),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer(
                      builder: (context, ref, child) {
                        // ref.read(ethUtilsNotifierProvider.notifier).approveConsent(hiuAddr)
                        return ref.watch(ethUtilsNotifierProvider).when(
                          data: (data) {
                            return ElevatedButton(
                              onPressed: () async {
                                // print((consents[index]).runtimeType);
                                // print((consents[index])['hiuAddress']);
                                if (await ref
                                        .read(ethUtilsNotifierProvider.notifier)
                                        .approveConsent(
                                            consents[index]['hiuAddress']) ==
                                    false) {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Consent Not given',
                                      ),
                                    ),
                                  );
                                } else {
                                  await ref
                                      .read(filemanagementNotifierProvider
                                          .notifier)
                                      .addFileExternalStorageDirectories(
                                          '/revokeConsent/${consents[index]['hiuAddress']}',
                                          json.encode(consents[index]));
                                  await ref
                                      .read(filemanagementNotifierProvider
                                          .notifier)
                                      .deleteFileExternalStorageDirectories(
                                          '/consent/${consents[index]['hiuAddress']}.txt');
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Consent Given',
                                      ),
                                    ),
                                  );
                                }
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
                                '/consent/${consents[index]['hiuAddress']}.txt');
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
          itemCount: consents.length,
        ),
      ),
    );
  }
}
