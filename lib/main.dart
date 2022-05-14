import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            width: 300,
            height: 300,
            color: Colors.yellow,
            child: CustomPaint(painter: FaceOutlinePainter()),
          ),
        ),
      ),
    );
  }
}

class FaceOutlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    Path path = Path();
    path.moveTo(0, size.height); //Ax, Ay

    path.cubicTo(
        size.width * 0.497,
        size.height * 0.847,
        size.width * 0.202,
        size.height * 0.4,
        size.width * 0.609,
        size.height * 0.256); //Bx, By, Cx, Cy
    canvas.drawPath(
        dashPath(path, dashArray: CircularIntervalList([15.0, 10.5])), paint);
    path.moveTo(0, size.height); //Ax, Ay
    path.cubicTo(
        size.width * 0.667,
        size.height * 0.998,
        size.width * 0.493,
        size.height * 0.38,
        size.width * 0.8,
        size.height * 0.3); //Bx, By, Cx, Cy

    canvas.drawPath(
        dashPath(path, dashArray: CircularIntervalList([15.0, 10.5])), paint);
  }

  @override
  bool shouldRepaint(FaceOutlinePainter oldDelegate) => false;
}
