import 'package:flutter/material.dart';
import 'package:todo_app/Screens/splash_screen.dart';
import 'package:todo_app/Screens/home_screen.dart';
import 'package:todo_app/Services/storage_service.dart';

class Todo extends StatelessWidget {
  const Todo({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _initApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!;
          if (data['isLoggedIn'] == true) {
            return HomeScreen(
              name: data['name'] ?? '',
              imagePath: data['imagePath'],
            );
          }
        }

        return const SplashScreen();
      },
    );
  }

  Future<Map<String, dynamic>> _initApp() async {
    try {
      bool isLoggedIn = await StorageService.isUserLoggedIn();
      Map<String, String?> userData = await StorageService.loadUser();

      await Future.delayed(const Duration(seconds: 3));

      return {
        'isLoggedIn': isLoggedIn,
        'name': userData['name'],
        'imagePath': userData['imagePath'],
      };
    } catch (e) {
      return {'isLoggedIn': false, 'name': null, 'imagePath': null};
    }
  }
}
