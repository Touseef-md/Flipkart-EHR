import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flipkart_ehr/provider/account_keys_provider.dart';
import 'package:flipkart_ehr/provider/filemanagement_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipkart_ehr/screens/hips/hip_registration_verification_screen.dart';
import 'package:flipkart_ehr/screens/hius/hiu_home_screen.dart';
import 'package:flipkart_ehr/screens/hius/hiu_registration_verification_screen.dart';
import 'package:flipkart_ehr/screens/patient/user_verification_screen.dart';
import 'package:flutter/material.dart';

//------------------------
class HomeScreen extends ConsumerStatefulWidget {
  static const routeName = '/home';
  HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? mtoken = "";
  late var documentId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
    getToken();
    initInfo();
  }

  void initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialize = const DarwinInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        try {
          print('INside the details');
          if (details != null) {
            // print()
            // print('These are the detailssssss${details.payload.runtimeType}');
            // var decodedPayload = json.decode(details.payload as String);
            // print('details as json${decodedPayload}');
            // print(decodedPayload['request_no']);
            // print(decodedPayload['request_no'].runtimeType);
            // if (decodedPayload['request_no'] == '2') {
            //   print('Request 2 is present');
            //   // storeApproveAppointment(decodedPayload);
            // }
            // print(
            //     'THis is the details received ${details.id},${details.input},${details.notificationResponseType},${details.payload}');
            // Navigator.pushNamed(
            //   context,
            //   ApproveDoctorScreen.routeName,
            //   arguments: details.payload,
            // );
          } else {
            print('Details are null');
          }
        } catch (err) {
          print('Error is ${err}');
        }
        return;
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('.......................on Message.................');
      print('THis is the message:${message.data}');
      print(
          'onMessage: ${message.notification?.title}/${message.notification?.body}');
      // await storeNewDoctor(message.data);
      // print('LIne after store function');
      if (message.data['request_no'] == '1') {
        print('THis is the phr received to the doctor');
        ref
            .read(filemanagementNotifierProvider.notifier)
            .addFileExternalStorageDirectories(
              '/consent/${(message.data['hiuAddress'] as String).toLowerCase()}',
              json.encode(message.data),
            );
        print(message.data);
        print('This is the ecoded data received:${json.encode(message.data)}');
        print(
            'Thi si the decode one:${json.decode(json.encode(message.data))}');
        // print(message.data);
        // await storePHR(message.data);
        // await ref.read(doctorNotifierProvider.notifier).getPHRs();
      } else if (message.data['request_no'] == '2') {
        print('Request no 2 is received...');
        ref
            .read(filemanagementNotifierProvider.notifier)
            .addFileExternalStorageDirectories(
              '/sendRecord/${(message.data['hiuAddress'] as String).toLowerCase()}',
              json.encode(message.data),
            );
        print(message.data);
        print('This is the ecoded data received:${json.encode(message.data)}');
        // print(
        // 'Thi si the decode one:${json.decode(json.encode(message.data))}');
      } else if (message.data['request_no'] == '3') {
        print(
            'Reqeusf no 3: ${(message.data['hiuAddress'] as String).toLowerCase()}');
        ref
            .read(filemanagementNotifierProvider.notifier)
            .addFileExternalStorageDirectories(
                'giveRecord/${(message.data['hiuAddress'] as String).toLowerCase()}',
                json.encode(message.data));
      } else if (message.data['request_no'] == '4') {
        print('Reacedfdsfsdf');
        ref
            .read(filemanagementNotifierProvider.notifier)
            .addFileExternalStorageDirectories(
                '/requestedRecord/${(message.data['patientAddress'] as String).toLowerCase()}',
                json.encode(message.data));
      }
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        '2',
        '2',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails(),
      );

// await FlutterLocalNotificationsPlugin.
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: json.encode(message.data));
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void saveToken() async {
    // documentId = ref.read(doctorNotifierProvider).value?.address;
    // print('Save token id ${documentId}');
    // print('${dotenv.env['ACCOUNT_ADDRESS']}');
    var address = ref.read(AccountAddressProvider);
    await FirebaseFirestore.instance
        .collection('UserTokens')
        .doc('${address.toLowerCase()}')
        .set({'token': mtoken});
  }

  void getToken() async {
    var result = await FirebaseMessaging.instance.getToken();
    setState(() {
      mtoken = result;
      print('My taken is ${mtoken}');
      saveToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryList = [
      'Patient',
      'HIP(Health Information Provider)',
      'HIU (Health Information User)'
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flipkart-EHR',
        ),
      ),
      body:
          // Center(
          //   child: Text('fdsf'),
          // ),
          Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   // mainAxisSize: MainAxisSize.values[0],
        children: [
          Card(
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(
            //     10,
            //   ),
            // ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              child: Text('Choose the one which best suites you',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          Container(
            // color: Colors.black,
            height: 150,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () {
                    if (categoryList[index] == 'Patient') {
                      ref.read(entityProvider.notifier).state = 1;
                      Navigator.pushNamed(
                          context, UserVerificationScreen.routeName);
                    } else if (categoryList[index] ==
                        'HIP(Health Information Provider)') {
                      ref.read(entityProvider.notifier).state = 2;
                      Navigator.pushNamed(
                          context, HIPRegistrationVerificationScreen.routeName);
                    } else {
                      ref.read(entityProvider.notifier).state = 3;
                      Navigator.pushNamed(
                        context,
                        HIURegistrationVerificationScreen.routeName,
                      );
                    }
                  },
                  child: Text(
                    categoryList[index],
                  ),
                  // style: Ele,
                );
              },
              itemCount: categoryList.length,
            ),
          )
        ],
      ),
    );
  }
}
