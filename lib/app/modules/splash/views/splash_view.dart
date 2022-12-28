import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:starter/app/modules/splash/controllers/splash_controller.dart';
import 'package:starter/app/theme/app_colors.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SplashView'),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
      ),
      body: const Center(
        child: Text(
          'SplashView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
