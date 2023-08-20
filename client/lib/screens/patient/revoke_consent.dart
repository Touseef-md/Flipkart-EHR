import 'dart:convert';
import 'package:flipkart_ehr/provider/eth_utils_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipkart_ehr/provider/filemanagement_provider.dart';
import 'package:flipkart_ehr/widgets/drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class RevokeConsent extends ConsumerStatefulWidget {
  static const routeName = '/revoke_consent';
  const RevokeConsent({super.key});

  @override
  ConsumerState<RevokeConsent> createState() => _RevokeConsentState();
}

class _RevokeConsentState extends ConsumerState<RevokeConsent> {
  late List revokeConsents = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRevokeConsents();
  }

  Future getRevokeConsents() async {
    final consentList = (await ref
        .read(filemanagementNotifierProvider.notifier)
        .getFilesFromDirectory('/revokeConsent')) as List<Future<dynamic>>?;
    revokeConsents = [];
    if (consentList != null)
      for (int i = 0; i < consentList.length; i++) {
        consentList[i].then((value) {
          setState(() {
            revokeConsents.add(value);
          });
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Revoke Consent',
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
                      child: Text((revokeConsents[index]).toString())),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return ref.watch(ethUtilsNotifierProvider).when(
                      data: (data) {
                        return ElevatedButton(
                          onPressed: () async {
                            await ref
                                .read(filemanagementNotifierProvider.notifier)
                                .deleteFileExternalStorageDirectories(
                                    '/revokeConsent/${revokeConsents[index]['hiuAddress']}.txt');
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Removed',
                                ),
                              ),
                            );
                          },
                          child: Text('Revoke'),
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
                )
              ],
            );
            return null;
          },
          itemCount: revokeConsents.length,
        ),
      ),
    );
  }
}
