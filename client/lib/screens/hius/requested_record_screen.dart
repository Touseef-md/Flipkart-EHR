import 'package:flipkart_ehr/widgets/drawer.dart';
import 'package:flutter/material.dart';

class RequestedRecordScreen extends StatelessWidget {
  static const routeName = '/requested_record';
  const RequestedRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Requested Record',
        ),
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Text(
          'fdsf',
        ),
      ),
    );
  }
}
