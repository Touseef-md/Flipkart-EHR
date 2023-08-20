// import 'package:flipkart_ehr/provider/account_keys_provider.dart';
import 'package:flipkart_ehr/provider/eth_utils_provider.dart';
import 'package:flipkart_ehr/provider/hiu_provider.dart';
// import 'package:flipkart_ehr/screens/hips/hip_home_screen.dart';
import 'package:flipkart_ehr/screens/hius/hiu_home_screen.dart';
import 'package:flipkart_ehr/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HIURegistrationVerificationScreen extends StatefulWidget {
  static const routeName = '/hiu_regis_veri';
  const HIURegistrationVerificationScreen({super.key});

  @override
  State<HIURegistrationVerificationScreen> createState() =>
      _HIURegistrationVerificationScreenState();
}

class _HIURegistrationVerificationScreenState
    extends State<HIURegistrationVerificationScreen> {
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
    // _aadharController.addListener(
    //   () {
    //     _aadharId = _aadharController.text;
    //   },
    // );
    // _verifyOTPController.addListener(() {
    //   _otpValue = _verifyOTPController.text;
    // });
    // _mobileController.addListener(() {
    //   _mobile = _mobileController.text;
    // });
  }

  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    // _aadharController.dispose();
    // _verifyOTPController.dispose();
    // _mobileController.dispose();
    super.dispose();
  }

  Future logic(BuildContext context, WidgetRef ref) async {
    if (_step == 0) {
      if (await ref.read(ethUtilsNotifierProvider.notifier).getIsHIU()) {
        await ref.read(hiuNotifierProvider.notifier).getHIU();
        Navigator.pushReplacementNamed(
          context,
          HIUHomeScreen.routeName,
        );
      } else {
        _controller1.text = '';
        _controller2.text = '';
        // ref.read(AccountAddressProvider.notifier).state = _controller1.text;
        // ref.read(AccountPrivateKeyProvider.notifier).state = _controller2.text;
        setState(() {
          _step = 1;
        });
      }
    } else if (_step == 1) {
      await ref
          .read(ethUtilsNotifierProvider.notifier)
          .addNewHIU(_controller1Value, _controller2Value);
      await ref
          .read(hiuNotifierProvider.notifier)
          .addNewHIU(_controller1Value, _controller2Value);
      // await ref.read(hiuNotifierProvider.notifier).hiu;
      // .name=_controller1Value;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(
            seconds: 1,
          ),
          content: Text(
            'Added Succeffully.',
          ),
        ),
      );
      Navigator.pushReplacementNamed(context, HIUHomeScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ID Generation/Verification',
        ),
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Text(
                'Create/Verify HIU ID',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          Column(
            children: [
              if (_step == 0) ...[
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
                        hintStyle: Theme.of(context).textTheme.labelLarge),
                  ),
                ),
                // if (_otp == 0)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: TextField(
                    controller: _controller2,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: InputDecoration(
                        hintText: 'Enter the Private Key of the Account',
                        hintStyle: Theme.of(context).textTheme.labelLarge),
                  ),
                ),
              ],
              if (_step == 1) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: TextField(
                    controller: _controller1,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: InputDecoration(
                        hintText: 'Enter the name of HIU',
                        hintStyle: Theme.of(context).textTheme.labelLarge),
                  ),
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
                        hintText: 'Enter the email of HIU',
                        hintStyle: Theme.of(context).textTheme.labelLarge),
                  ),
                ),
              ],
              Consumer(
                builder: (context, ref, child) {
                  return ref.watch(ethUtilsNotifierProvider).when(
                    data: (data) {
                      return ElevatedButton(
                        child: const Text(
                          'Submit',
                        ),
                        onPressed: () async {
                          await logic(context, ref);
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      return Text('Oops! Something went wrong');
                    },
                    loading: () {
                      return CircularProgressIndicator();
                    },
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
