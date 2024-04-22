import 'package:book_grocer/view/main_tab/main_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
            _supportState = isSupported;
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: ElevatedButton(
              onPressed: _authenticate,
              child: Text('Authenticate', style: TextStyle(fontSize: 20),),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Verify ...',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      print("Authenticated : $authenticated");

      if (authenticated) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainTabView()), // navigate to Screen2
        );
      }
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) {
      return;
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

    print("List of availableBiometrics : $availableBiometrics");

    if (!mounted) {
      return;
    }
  }
}
