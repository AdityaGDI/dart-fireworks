import 'dart:io';
import 'dart:async';
import 'dart:math';

const colors = [
  '\x1B[32m', // Green
  '\x1B[37m', // White
  '\x1B[31m', // Red
  '\x1B[35m', // Purple
  '\x1B[34m', // Blue
  '\x1B[33m', // Yellow
];
const resetColor = '\x1B[0m';

const explosionShapes = ['star', 'heart', 'circle'];

void main() async {
  stdout.write('Enter the number of fireworks: ');
  final fireworkCount = int.parse(stdin.readLineSync() ?? '3');

  await runFireworks(fireworkCount);
  await animateHBD();
  stdout.write(resetColor);  
}

Future<void> runFireworks(int count) async {
  final random = Random();
  print("Starting fireworks...");

  final width = 120;
  final height = 40;

  for (int i = 0; i < count; i++) {
    final fireworkX = i == 0 ? width ~/ 2 : random.nextInt(width);
    final fireworkY = height - 1;

    final backgroundColor = colors[random.nextInt(colors.length)];
    stdout.write('\x1B[48;5;${backgroundColor.substring(2)}m'); 

    String fireworkColor = (i == 0) ? colors[0] : backgroundColor;

    await animateFirework(fireworkX, fireworkY, fireworkColor);
    await animateExplosion(fireworkX, 0, explosionShapes[random.nextInt(explosionShapes.length)],
        fireworkColor);

    await Future.delayed(Duration(seconds: random.nextInt(2) + 1));
  }

  stdout.write(resetColor); 
}

Future<void> animateFirework(int x, int startY, String color) async {
  for (int i = startY; i >= 0; i--) {
    stdout.write('\x1B[2J\x1B[0;0H');
    
    for (int j = 0; j < i; j++) {
      stdout.writeln();
    }
    
    stdout.writeln(' ' * x + '${color}*${resetColor}'); 
    await Future.delayed(Duration(milliseconds: 50));
  }
}

Future<void> animateExplosion(int x, int y, String shape, String color) async {
  stdout.write('\x1B[2J\x1B[0;0H');

  for (int size = 1; size <= 3; size++) {
    stdout.write('\x1B[2J\x1B[0;0H');

    switch (shape) {
      case 'star':
        drawStarExplosion(x, y, size, color);
        break;
      case 'heart':
        drawHeartExplosion(x, y, size, color);
        break;
      case 'circle':
        drawCircleExplosion(x, y, size, color);
        break;
    }

    await Future.delayed(Duration(milliseconds: 300));
  }
}

void drawStarExplosion(int x, int y, int size, String color) {
  final star = [
    ['  *  ', ' *** ', '*****', ' *** ', '  *  '],
    ['   *   ', '  ***  ', ' ***** ', '*******', ' ***** ', '  ***  ', '   *   '],
    ['    *    ', '   ***   ', '  *****  ', ' ******* ', '*********', ' ******* ', '  *****  ', '   ***   ', '    *    ']
  ][size - 1];

  for (int i = 0; i < star.length; i++) {
    stdout.writeln(' ' * x + color + star[i] + resetColor);
  }
}

void drawHeartExplosion(int x, int y, int size, String color) {
  final heart = [
    ['**  **', '******', ' **** '],
    [' **   ** ', '*********', ' *******', '  ***** ', '   ***  '],
    ['  **     **  ', ' ****** ****** ', ' ************ ', '  **********  ', '   *******   ', '    *****    ', '     ***     ']
  ][size - 1];

  for (int i = 0; i < heart.length; i++) {
    stdout.writeln(' ' * x + color + heart[i] + resetColor);
  }
}

void drawCircleExplosion(int x, int y, int size, String color) {
  final circle = [
    [' *** ', '*****', ' *** '],
    ['  ***  ', ' ***** ', '*******', ' ***** ', '  ***  '],
    ['   ***   ', '  *****  ', ' ******* ', '*********', ' ******* ', '  *****  ', '   ***   ']
  ][size - 1];

  for (int i = 0; i < circle.length; i++) {
    stdout.writeln(' ' * x + color + circle[i] + resetColor);
  }
}

Future<void> animateHBD() async {
  final width = 120;
  final height = 40;

  final bigMessage = [
    "HHHHH  BBBBB   DDDDD    PPPPP   AAAAA  K   K     AAAAA  RRRRR  N   N  OOOOO  L     DDDDD ",
    "H   H  B    B  D    D   P    P  A   A  K  K      A   A  R    R  NN  N  O   O  L     D    D",
    "HHHHH  BBBBB   D     D  PPPPP   AAAAA  KKK       AAAAA  RRRRR   N N N  O   O  L     D     D",
    "H   H  B    B  D    D   P       A   A  K  K      A   A  R   R   N  NN  O   O  L     D    D",
    "H   H  BBBBB   DDDDD    P       A   A  K   K     A   A  R    R  N   N  OOOOO  LLLLL DDDDD "
  ];

  for (int i = 0; i < bigMessage.length; i++) {
    stdout.write('\x1B[2J\x1B[0;0H');
    int verticalOffset = (height ~/ 2) - (bigMessage.length ~/ 2) + i;

    for (int j = 0; j <= i; j++) {
      stdout.writeln(' ' * ((width - bigMessage[j].length) ~/ 2) + bigMessage[j]);
    }

    await Future.delayed(Duration(milliseconds: 500));
  }
}
