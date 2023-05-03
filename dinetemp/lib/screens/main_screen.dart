import 'package:flutter/material.dart';
import '../constants/constants.dart';
import 'categories_list.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(kAppName),
        ),
        body: ListView(
          children: [
            Image.asset(kLogo),
            const SizedBox(height: 20),
            const SizedBox(
              height: 500,
              child: CategoriesList(),
            ),
          ],
        ),
      ),
    );
  }
}
