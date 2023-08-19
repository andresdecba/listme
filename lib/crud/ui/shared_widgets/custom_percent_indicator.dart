import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CustomPercentIndicator extends StatefulWidget {
  const CustomPercentIndicator({
    required this.lista,
    super.key,
  });

  final Lista lista;
  @override
  State<CustomPercentIndicator> createState() => _CustomPercentIndicatorState();
}

class _CustomPercentIndicatorState extends State<CustomPercentIndicator> {
  late Box<Lista> _db;
  @override
  void initState() {
    super.initState();
    _db = Hive.box<Lista>(AppConstants.listasDb);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme style = Theme.of(context).textTheme;

    return ValueListenableBuilder(
      valueListenable: _db.listenable(),
      builder: (context, value, child) {
        // calculate
        int done = 0;
        int undone = widget.lista.items.length;
        double percentage = 0;
        for (var element in widget.lista.items) {
          if (element.isDone) {
            done++;
          }
        }
        if (undone > 0) {
          percentage = (done / undone);
        }

        // widget
        return CircularPercentIndicator(
          radius: 25,
          lineWidth: 5.0,
          percent: percentage,
          center: Text(
            '$done/$undone',
            style: style.labelSmall,
          ),
          progressColor: Colors.cyan,
          circularStrokeCap: CircularStrokeCap.round,
        );
      },
    );
  }
}
