import 'package:flipkart_ehr/screens/hips/hip_home_screen.dart';
import 'package:flipkart_ehr/screens/hius/hiu_home_screen.dart';
import 'package:flipkart_ehr/screens/hius/hiu_registration_verification_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipkart_ehr/screens/patient/patient_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './screens/patient/user_verification_screen.dart';
import './screens/hips/hip_registration_verification_screen.dart';
import './screens/patient/approve_consent_screen.dart';
import './screens/patient/revoke_consent.dart';
import './screens/hips/send_record_screen.dart';
import './screens/hips/records_screen.dart';
import './screens/hius/requested_record_screen.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message${message.messageId}');
  print(message.data);
  print(message.notification?.title);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flipkar EHR',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green, // Choose your primary color swatch

        // Define the default font family for the entire app
        fontFamily: 'Roboto',

        // Define the text theme for the app
        textTheme: const TextTheme(
          // titleLarge: TextStyle(
          //   color: Colors.white,
          // ),
          titleMedium: TextStyle(
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
              // color: Colors.white,
              ),
          bodyMedium: TextStyle(color: Colors.white),
          labelLarge: TextStyle(
            color: Colors.black,
          ),
          // headlineLarge:
          // ,
          // headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          // headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          // headline3: TextStyle(
          //     fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
          // headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          // headline5: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          // headline6: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          // subtitle1: TextStyle(fontSize: 16.0),
          // subtitle2: TextStyle(fontSize: 14.0),
          // // bodyText1: TextStyle(fontSize: 16.0, color: Colors.white),
          // bodyText2: TextStyle(fontSize: 14.0, color: Colors.white),
          // caption: TextStyle(fontSize: 12.0),
          // button: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),

        // Use colorScheme to define your color palette
        colorScheme: const ColorScheme.light(
          primary: Colors
              .green, // Customize the primary color (same as primarySwatch)
          secondary: Colors.blue, // Customize the secondary color
          background: Colors.white, // Customize the background color
          onPrimary:
              Colors.white, // Customize the color for elements on primary color
          onSecondary: Colors
              .white, // Customize the color for elements on secondary color
          onBackground:
              Colors.black, // Customize the color for elements on background
        ),
        // ... (Other theme properties remain the same)

// With this update, we've changed the primary color from blue to green in the colorScheme, which will affect various UI elements throughout the app, such as app bars, buttons, and more. You can choose any color you like by using the appropriate Colors constant from Flutter.

        // Define the app bar theme
        appBarTheme: const AppBarTheme(
          color: Colors
              .amber, // Use primary color from colorScheme as app bar color
          elevation: 0, // Remove the shadow from the app bar
          iconTheme:
              IconThemeData(color: Colors.black), // Customize the app bar icons
          titleTextStyle: TextStyle(
            color: Colors.black, // Customize the app bar text color
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Define the button theme
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8.0), // Customize the button shape
          ),
          textTheme: ButtonTextTheme.primary,
        ),

        // Define the card theme
        cardTheme: CardTheme(
          color: Colors.black87,
          elevation: 2, // Customize the card elevation
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(35.0), // Customize the card shape
          ),
          surfaceTintColor: Colors.red,
        ),

        // Define the input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(8.0), // Customize the text field border
          ),
        ),

        // Define the floating action button theme
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor:
              Colors.greenAccent, // Use secondary color from colorScheme
          foregroundColor: Colors.white, // Customize the FAB icon color
        ),

        // Define the bottom navigation bar theme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.blue, // Customize the selected item color
          unselectedItemColor:
              Colors.grey, // Customize the unselected item color
          showUnselectedLabels: true, // Show labels for unselected items
        ),
      ),
      home: HomeScreen(),
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        UserVerificationScreen.routeName: (context) => UserVerificationScreen(),
        PatientHomeScreen.routeName: (context) => PatientHomeScreen(),
        HIPRegistrationVerificationScreen.routeName: (context) =>
            HIPRegistrationVerificationScreen(),
        HIPHomeScreen.routeName: (context) => HIPHomeScreen(),
        HIURegistrationVerificationScreen.routeName: (context) =>
            HIURegistrationVerificationScreen(),
        HIUHomeScreen.routeName: (context) => HIUHomeScreen(),
        ApproveConsentScreen.routeName: (context) => ApproveConsentScreen(),
        RevokeConsent.routeName: (context) => RevokeConsent(),
        SendRecordScreen.routeName: (context) => SendRecordScreen(),
        RecordsScreen.routeName: (context) => RecordsScreen(),
        RequestedRecordScreen.routeName: (context) => RequestedRecordScreen(),
      },
    );
  }
}
