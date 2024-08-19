// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:academy_app/constants.dart';
import 'package:academy_app/providers/auth.dart';
import 'package:academy_app/screens/auth_screen_private.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
import 'package:provider/provider.dart';

import '../providers/shared_pref_helper.dart';
import 'tabs_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  dynamic courseAccessibility;

  systemSettings() async {
    var url = "$BASE_URL/api/system_settings";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        courseAccessibility = data['course_accessibility'];
      });
    } else {
      setState(() {
        courseAccessibility = '';
      });
    }
  }

  Future<void> checkDeviceBinding() async {
    String? authToken = await SharedPreferenceHelper().getAuthToken();

    if (authToken == null || authToken.isEmpty) {
      return;
    }
    final deviceId = base64.encode(utf8.encode((await MobileDeviceIdentifier().getDeviceId())!));
    String udid = await FlutterUdid.consistentUdid;

    var url = "$BASE_URL/api/device_binding?token=$authToken";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      // compare the device id and udid with the data from the server
      if (data['deviceid'] != deviceId || data['udid'] != udid) {
        // if the device id and udid are not the same, log out the user
        await Provider.of<Auth>(context, listen: false).logout();
      }
    }
  }

  @override
  void initState() {
    donLogin();
    systemSettings();
    super.initState();
  }

  void donLogin() {
    String? token;
    Future.delayed(const Duration(seconds: 3), () async {
      await checkDeviceBinding();
      token = await SharedPreferenceHelper().getAuthToken();
      if (token != null && token!.isNotEmpty) {
        await Provider.of<Auth>(context, listen: false).getLocalUserInfo();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const TabsScreen()));
      } else {
        if (courseAccessibility == 'publicly') {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const TabsScreen()));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthScreenPrivate()));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Image.asset(
            'assets/images/splash.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
