import 'package:flipkart_ehr/provider/eth_utils_provider.dart';
import 'package:flipkart_ehr/screens/hips/hip_home_screen.dart';
import 'package:flipkart_ehr/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HIPRegistrationVerificationScreen extends StatefulWidget {
  static const routeName = '/hip_regis_veri';
  const HIPRegistrationVerificationScreen({super.key});

  @override
  State<HIPRegistrationVerificationScreen> createState() =>
      _HIPRegistrationVerificationScreenState();
}

class _HIPRegistrationVerificationScreenState
    extends State<HIPRegistrationVerificationScreen> {
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
      if (await ref.read(ethUtilsNotifierProvider.notifier).getIsHIP()) {
        Navigator.pushReplacementNamed(context, HIPHomeScreen.routeName);
      } else {
        _controller1.text = '';
        _controller2.text = '';

        setState(() {
          _step = 1;
        });
      }
    } else if (_step == 1) {
      await ref
          .read(ethUtilsNotifierProvider.notifier)
          .addNewHIP(_controller1Value, _controller2Value);
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Added Succeffully.',
          ),
        ),
      );
      Navigator.pushReplacementNamed(context, HIPHomeScreen.routeName);
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
                'Create/Verify ID',
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
                        hintText: 'Enter the name of HIP',
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
                        hintText: 'Enter the email of HIP',
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
