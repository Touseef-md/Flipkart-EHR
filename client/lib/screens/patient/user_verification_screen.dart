import 'dart:math';

import 'package:flipkart_ehr/provider/abha_provider.dart';
import 'package:flipkart_ehr/provider/account_keys_provider.dart';
import 'package:flipkart_ehr/provider/eth_utils_provider.dart';
import 'package:flipkart_ehr/screens/patient/patient_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/drawer.dart';

class UserVerificationScreen extends ConsumerStatefulWidget {
  static const routeName = '/patient_verification';
  const UserVerificationScreen({super.key});

  @override
  ConsumerState<UserVerificationScreen> createState() =>
      _UserVerificationScreenState();
}

class _UserVerificationScreenState
    extends ConsumerState<UserVerificationScreen> {
  TextEditingController _aadharController = TextEditingController();
  TextEditingController _verifyOTPController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();

  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  int _otp = 0;
  String _controller1Value = '';
  String _controller2Value = '';
  String _aadharId = '';
  String _otpValue = '';
  String _mobile = '';

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
    _aadharController.addListener(
      () {
        _aadharId = _aadharController.text;
      },
    );
    _verifyOTPController.addListener(() {
      _otpValue = _verifyOTPController.text;
    });
    _mobileController.addListener(() {
      _mobile = _mobileController.text;
    });
  }

  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _aadharController.dispose();
    _verifyOTPController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future logic(BuildContext context) async {
    print('BUtton pressed');
    if (_otp == 0) {
      // ref.read(AccountAddressProvider.notifier).state =
      // _controller1Value;
      // ref.read(AccountPrivateKeyProvider.notifier).state =
      // _controller2Value;
      // print(
      // 'Account address:${ref.read(AccountAddressProvider)}');
      // print('Private Key:${AccountPrivateKeyProvider}');
      _controller1.text = '';
      _controller2.text = '';

      if (await ref.read(ethUtilsNotifierProvider.notifier).getIsPatient()) {
        print('Patient already registered with this address');
        Navigator.pushReplacementNamed(context, PatientHomeScreen.routeName);
      } else {
        print('Patient not registered with this address');
        setState(() {
          _otp = 1;
        });
      }
      print('Value of _otp:${_otp}');
    } else if (_otp == 1) {
      // print('THis is the :${_aadharId}');
      // await ref
      // .read(ABHANotifierProvider.notifier)
      // .aadharGenerateOtp(_aadharId);
      if (await ref
          .read(ethUtilsNotifierProvider.notifier)
          .checkPatientAgainstAadhar(_aadharId)) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'You have already a address linked to this Aadhaar number',
            ),
          ),
        );
      } else {
        await ref
            .read(ethUtilsNotifierProvider.notifier)
            .addNewPatient(_aadharId);
        Navigator.pushReplacementNamed(context, PatientHomeScreen.routeName);
        print('Else part ...');
      }
      // setState(() {
      //   _otp = 2;
      // });
    } else if (_otp == 2) {
      // await ref
      // .read(ABHANotifierProvider.notifier)
      // .aadhaarVerifyOTP(_otpValue);
      setState(() {
        _otp = 4;
      });
    } else if (_otp == 3) {
      // await ref
      // .read(ABHANotifierProvider.notifier)
      // .generateMobileOTP(_mobile);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Build called');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ID Generation/Verification',
        ),
      ),
      drawer: CustomDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Text(
                'Create ID',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          Column(
            children: [
              if (_otp == 0) ...[
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 10,
                //     vertical: 5,
                //   ),
                //   child: TextField(
                //     controller: _controller1,
                //     style: Theme.of(context).textTheme.bodyLarge,
                //     decoration: InputDecoration(
                //         hintText: 'Enter Ethereum Account Address',
                //         hintStyle: Theme.of(context).textTheme.labelLarge),
                //   ),
                // ),
                // // if (_otp == 0)
                // Padding(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 10,
                //     vertical: 5,
                //   ),
                //   child: TextField(
                //     controller: _controller2,
                //     style: Theme.of(context).textTheme.bodyLarge,
                //     decoration: InputDecoration(
                //         hintText: 'Enter the Private Key of the Account',
                //         hintStyle: Theme.of(context).textTheme.labelLarge),
                //   ),
                // ),
              ],
              if (_otp == 1)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: TextField(
                    controller: _aadharController,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: InputDecoration(
                        hintText: 'Enter the Aadhar number',
                        hintStyle: Theme.of(context).textTheme.labelLarge),
                  ),
                ),
              if (_otp == 2)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: TextField(
                    controller: _verifyOTPController,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: InputDecoration(
                        hintText:
                            'Enter the OTP sent to the registered Aadhaar numer',
                        hintStyle: Theme.of(context).textTheme.labelLarge),
                  ),
                ),
              if (_otp == 3)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: TextField(
                    controller: _mobileController,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: InputDecoration(
                        hintText:
                            'Enter the mobile number of Flipkart-EHR communication',
                        hintStyle: Theme.of(context).textTheme.labelLarge),
                  ),
                ),
              ElevatedButton(
                child: const Text(
                  'Submit',
                ),
                onPressed: () async {
                  await logic(context);
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
