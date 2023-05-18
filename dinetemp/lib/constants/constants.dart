import 'package:flutter/material.dart';

//name
String kAppName = 'الشيخ عبدالمحسن بن محمد الأحمد';

//Links
String kUrl = 'https://www.shanqiti.com';

//Colors
Color getMaterialColor = const Color.fromARGB(255, 4, 27, 235);
MaterialColor kMainColor = MaterialColorGenerator.from(getMaterialColor);
Color kIconColor = Colors.grey;
Color kGradianColor1 = const Color(0xFF144771);
Color kGradianColor2 = const Color(0Xff071A2C);

//images
String kLogo = 'assets/images/logo.png';
String kSoundImage =
    'https://as1.ftcdn.net/v2/jpg/00/85/61/98/1000_F_85619893_qcV9Vr8GQGGToKKozmKZlon9M1rNwWNd.jpg';

//
//
class MaterialColorGenerator {
  static MaterialColor from(Color color) {
    return MaterialColor(color.value, <int, Color>{
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color.withOpacity(0.6),
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1.0),
    });
  }
}
