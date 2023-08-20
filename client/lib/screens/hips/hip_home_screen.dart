import 'dart:convert';
import 'package:flipkart_ehr/provider/account_keys_provider.dart';
import 'package:flipkart_ehr/provider/eth_utils_provider.dart';
import 'package:flipkart_ehr/provider/filemanagement_provider.dart';
import 'package:flipkart_ehr/widgets/drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class HIPHomeScreen extends ConsumerStatefulWidget {
  static const routeName = 'hip_home';
  const HIPHomeScreen({super.key});

  @override
  ConsumerState<HIPHomeScreen> createState() => _HIPHomeScreenState();
}

class _HIPHomeScreenState extends ConsumerState<HIPHomeScreen> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  String _controller1Value = '';
  String _controller2Value = '';
  int _step = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller1.addListener(() {
      _controller1Value = _controller1.text;
    });
    _controller2.addListener(() {
      _controller2Value = _controller2.text;
    });
  }

  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
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
          Text(
            'Add Record',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 1,
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
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 1,
              vertical: 5,
            ),
            child: TextField(
              controller: _controller2,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Enter health related description',
                hintStyle: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(filemanagementNotifierProvider.notifier)
                  .addFileExternalStorageDirectories(
                    '/record/${_controller1.text.toLowerCase()}',
                    json.encode(_controller2Value),
                  );
              await ref
                  .read(ethUtilsNotifierProvider.notifier)
                  .addRecord(_controller1Value);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Record Added Successfully',
                  ),
                ),
              );
              _controller1.text = '';
              _controller2.text = '';
            },
            child: Text(
              'Add record',
            ),
          ),
        ],
      ),
    );
  }
}
