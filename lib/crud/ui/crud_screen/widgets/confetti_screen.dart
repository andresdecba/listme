import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/crud/models/lista.dart';

class ConfettiScreen extends StatefulWidget {
  const ConfettiScreen({
    required this.child,
    required this.lista,
    super.key,
  });

  final Widget child;
  final Lista lista;

  @override
  State<ConfettiScreen> createState() => _ConfettiScreenState();
}

class _ConfettiScreenState extends State<ConfettiScreen> {
  late ConfettiController _controller;
  late Box<Lista> _listaDb;

  @override
  void initState() {
    super.initState();
    _listaDb = Hive.box<Lista>(AppConstants.listasDb);
    _controller = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step), halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep), halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ValueListenableBuilder(
          valueListenable: _listaDb.listenable(),
          builder: (context, value, child) {
            // TODO resolver:
            // 1- el confetti se dispara todo el tiempo
            // 2- se dispara cada vez que entramos a la lista completada
            if (widget.lista.isCompleted) {
              _controller.play();
            }

            // confetti
            return Stack(
              children: [
                // lista - pantalla
                widget.child,

                // confetti
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ConfettiWidget(
                    confettiController: _controller,
                    shouldLoop: false, // start again as soon as the animation is finished
                    colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple], // manually specify the colors to be used
                    createParticlePath: drawStar, // define a custom shape/path.
                    emissionFrequency: 0.02,
                    numberOfParticles: 10,
                    minBlastForce: 50,
                    maxBlastForce: 100,
                    blastDirection: -pi / 2,
                    gravity: 0.02,
                  ),
                ),
              ],
            );
          },
        ));
  }
}
