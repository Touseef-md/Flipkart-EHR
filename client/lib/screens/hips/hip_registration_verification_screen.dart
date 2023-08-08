import 'package:flipkart_ehr/widgets/drawer.dart';
import 'package:flutter/material.dart';

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

  Future logic(BuildContext context)async{

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
              ElevatedButton(
                child: const Text(
                  'Submit',
                ),
                onPressed: () async {
                  await logic(context);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
