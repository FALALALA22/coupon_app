import 'package:flutter/material.dart';
import 'package:coupon_app/HomePage.dart';
import 'package:coupon_app/LoginPage.dart';
import 'package:coupon_app/RegisterPage.dart';
import 'package:coupon_app/user_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/main': (context) => HomePage(),
      },
    );
  }
}
