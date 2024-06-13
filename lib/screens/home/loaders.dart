// import 'dart:math';

// import 'package:flutter/material.dart';

// class Spiral extends StatefulWidget {
//   final double size;
//   final double speed;
//   final Color color;

//   Spiral({this.size = 40, this.speed = 0.9, this.color = Colors.black});

//   @override
//   _SpiralState createState() => _SpiralState();
// }

// class _SpiralState extends State<Spiral> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 1),
//     )..repeat();
//     _animation = Tween(begin: 0.0, end: 2 * pi * widget.size)
//         .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return CustomPaint(
//           size: Size(200, 200),
//           painter: SpiralPainter(
//             angle: _animation.value,
//             size: widget.size,
//             color: widget.color,
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

// class SpiralPainter extends CustomPainter {
//   final double angle;
//   final double size;
//   final Color color;

//   SpiralPainter({required this.angle, required this.size, required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final double centerX = size.width / 2;
//     final double centerY = size.height / 2;
//     final double radius = min(centerX, centerY);

//     final Paint paint = Paint()
//       ..color = color
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;

//     canvas.save();
//     canvas.translate(centerX, centerY);
//     canvas.rotate(angle);

//     for (double i = 0; i <= angle; i += 0.1) {
//       final double x = i * cos(i * widget.speed);
//       final double y = i * sin(i * widget.speed);
//       canvas.drawPoint(Offset(x, y), paint);
//     }

//     canvas.restore();
//   }

//   @override
//   bool shouldRepaint(SpiralPainter oldDelegate) =>
//       angle != oldDelegate.angle || color != oldDelegate.color;
// }