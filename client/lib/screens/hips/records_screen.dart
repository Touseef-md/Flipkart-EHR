import 'dart:convert';
import 'package:flipkart_ehr/provider/eth_utils_provider.dart';
import 'package:flipkart_ehr/provider/filemanagement_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipkart_ehr/widgets/drawer.dart';
import 'package:flutter/material.dart';

class RecordsScreen extends ConsumerStatefulWidget {
  static const routeName = '/records';
  const RecordsScreen({super.key});

  @override
  ConsumerState<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends ConsumerState<RecordsScreen> {
  void initState() {
    super.initState();
    getRecords();
  }

  List records = [];
  Future getRecords() async {
    final recordsList = (await ref
        .read(filemanagementNotifierProvider.notifier)
        .getFilesFromDirectory('/record')) as List<Future<dynamic>>?;
    records = [];
    if (recordsList != null)
      for (int i = 0; i < recordsList.length; i++) {
        recordsList[i].then((value) {
          setState(() {
            records.add(value);
          });
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Records',
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
                      child: Text((records[index]).toString())),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Consumer(
                //       builder: (context, ref, child) {
                //         // ref.read(ethUtilsNotifierProvider.notifier).approveConsent(hiuAddr)
                //         return ref.watch(ethUtilsNotifierProvider).when(
                //           data: (data) {
                //             return ElevatedButton(
                //               onPressed: () async {
                //                 // print((consents[index]).runtimeType);
                //                 // print((consents[index])['hiuAddress']);
                //                 if (await ref
                //                         .read(ethUtilsNotifierProvider.notifier)
                //                         .approveConsent(
                //                             records[index]['hiuAddress']) ==
                //                     false) {
                //                   ScaffoldMessenger.of(context)
                //                       .clearSnackBars();
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                       content: Text(
                //                         'Consent Not given',
                //                       ),
                //                     ),
                //                   );
                //                 } else {
                //                   await ref
                //                       .read(filemanagementNotifierProvider
                //                           .notifier)
                //                       .addFileExternalStorageDirectories(
                //                           '/revokeConsent/${records[index]['hiuAddress']}',
                //                           json.encode(records[index]));
                //                   await ref
                //                       .read(filemanagementNotifierProvider
                //                           .notifier)
                //                       .deleteFileExternalStorageDirectories(
                //                           '/consent/${records[index]['hiuAddress']}.txt');
                //                   ScaffoldMessenger.of(context)
                //                       .clearSnackBars();
                //                   ScaffoldMessenger.of(context).showSnackBar(
                //                     SnackBar(
                //                       content: Text(
                //                         'Consent Given',
                //                       ),
                //                     ),
                //                   );
                //                 }
                //                 // print('THis is the object:${json.decode(consents[index])}');
                //                 // _approve = true;
                //                 // approveOrReject(appointments[index]);
                //               },
                //               child: Text('Approve'),
                //             );
                //           },
                //           error: (error, stackTrace) {
                //             return Text('OOps! Something went wrong');
                //           },
                //           loading: () {
                //             return CircularProgressIndicator();
                //           },
                //         );
                //       },
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     ElevatedButton(
                //       onPressed: () async {
                //         await ref
                //             .read(filemanagementNotifierProvider.notifier)
                //             .deleteFileExternalStorageDirectories(
                //                 '/consent/${records[index]['hiuAddress']}.txt');
                //         ScaffoldMessenger.of(context).clearSnackBars();
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           SnackBar(
                //             content: Text(
                //               'Removed',
                //             ),
                //           ),
                //         );
                //         // _approve = false;
                //         // approveOrReject(appointments[index]);
                //       },
                //       child: Text('Reject'),
                //     )
                //   ],
                // )
              ],
            );
            return null;
          },
          itemCount: records.length,
        ),
      ),
    );
  }
}
