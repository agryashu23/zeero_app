import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color whiteA7007f = fromHex('#7fffffff');

  static Color whiteA7004c = fromHex('#4cffffff');

  static Color whiteA70033 = fromHex('#33ffffff');
  static Color starr = fromHex('#4E8903');


  static Color gray600 = fromHex('#858585');
  static Color male = fromHex('#1400FF');
  static Color female = fromHex('#FF0000');

  static Color online = fromHex('#1DD100');


  static Color deepPurple900 = fromHex('#0f00c4');



  static Color whiteA70066 = fromHex('#66ffffff');

  static Color textStart = fromHex('#1000C6');

  static Color textEnd = fromHex('#C600BE');

  static Color lime400 = fromHex('#bad95c');

  static Color black90033 = fromHex('#33000000');

  static Color red504c = fromHex('#4cfff2f2');

  static Color black90019 = fromHex('#19000000');

  static Color whiteA700 = fromHex('#ffffff');

  static Color green500 = fromHex('#45d461');

  static Color black900 = fromHex('#000000');

  static Color bluegray400 = fromHex('#8c8c8c');

  static Color whiteA70026 = fromHex('#26ffffff');

  static Color lightGreenA700 = fromHex('#1cd100');

  static Color whiteA70019 = fromHex('#19ffffff');

  static Color purple500 = fromHex('#c400bd');

  static Color gray200 = fromHex('#ededed');

  static Color black9004c = fromHex('#4c000000');


  static Color gray601 = fromHex('#6b6b6b');


  static Color black90026 = fromHex('#26000000');
  static Color black9001a = fromHex('#1a000000');

  static Color indigoA700 = fromHex('#000aff');




  static Color gray500 = fromHex('#969696');


  static Color whiteA7000c = fromHex('#0cffffff');

  static Color gray800 = fromHex('#454545');


  static Color deepPurple901 = fromHex('#330099');

  static Color bluegray100 = fromHex('#cccccc');

  static Color deepPurple40066 = fromHex('#668f3bcf');


  static Color gray201 = fromHex('#e8e8e8');

  static Color whiteA7003f = fromHex('#3fffffff');

  static Color whiteA700B2 = fromHex('#b2ffffff');


  static Color gray400 = fromHex('#c7c7c7');


  static Color gray602 = fromHex('#707070');

  static Color gray900 = fromHex('#1a1a1a');

  static Color whiteA70099 = fromHex('#99ffffff');

  static Color greenA700 = fromHex('#0ad45c');



  static Color whiteA70075 = fromHex('#75ffffff');

  static Color black90040 = fromHex('#40000000');

  static Color purpleA400 = fromHex('#d40ded');


  static Color black90002 = fromHex('#02000000');

  static Color yellow100 = fromHex('#fff5bf');


  static Color gray700 = fromHex('#696969');


  static Color gray401 = fromHex('#c2bfbf');

  static Color lime600 = fromHex('#ccb84a');

  static Color lime900 = fromHex('#875900');


  static Color lime901 = fromHex('#8a5900');


  static Color lightGreenA100 = fromHex('#d4ff9e');

  static Color lightGreenA200 = fromHex('#b5ff59');

  static Color lightGreen900 = fromHex('#5c450a');

  static Color lightGreen800 = fromHex('#4f8a03');

  static Color lime200 = fromHex('#e8d4a1');

  static Color orangeA100 = fromHex('#ffd66e');

  static Color blue900 = fromHex('#004099');


  static Color lime800 = fromHex('#a6804a');

  static Color amber100 = fromHex('#ffedbd');

  static Color orange700 = fromHex('#d18a00');

  static Color blue100 = fromHex('#bfe8ff');

  static Color cyanA400 = fromHex('#00d9f5');


  static Color tealA400 = fromHex('#00f5a1');

  static Color purple5000c = fromHex('#0cc400bd');


  static Color deepPurple9000c = fromHex('#0c0f00c4');


  static Color bluegray401 = fromHex('#878787');


  static Color deepPurple90019 = fromHex('#190f00c4');


  static Color lime800E5 = fromHex('#e5b08721');


  static Color gray900E5 = fromHex('#e5473608');


  static Color purple50019 = fromHex('#19c400bd');


  static Color black90014 = fromHex('#14000000');


  static Color redA700 = fromHex('#ff0000');

  static Color deepPurpleA700 = fromHex('#5400c2');

  static Color black90080 = fromHex('#80000000');

  static Color gray50 = fromHex('#fff7f7');


  static Color purpleA400D1 = fromHex('#d1fb00b5');


  static Color blue90066 = fromHex('#660014cc');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
