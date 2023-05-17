import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Services/spalsh_services.dart';

class SplashViewModel extends StatefulWidget {
  const SplashViewModel({super.key});

  @override
  State<SplashViewModel> createState() => _SplashViewModelState();
}

class _SplashViewModelState extends State<SplashViewModel> {
  SplashServics splashServics = SplashServics();

  @override
  void initState() {
    super.initState();
    splashServics.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitWave(
          color: Colors.grey.shade400,
          size: 40,
          type: SpinKitWaveType.center,
        ),
      ),
    );
  }
}
