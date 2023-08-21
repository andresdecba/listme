import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/crud/models/lista.dart';
import 'package:percent_indicator/percent_indicator.dart';

enum CustomPercentIndicatorSize { big, small }

class CustomPercentIndicator extends StatefulWidget {
  const CustomPercentIndicator({
    required this.lista,
    this.size = CustomPercentIndicatorSize.small,
    super.key,
  });

  final Lista lista;
  final CustomPercentIndicatorSize size;
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
        int undone = 0;
        double percentage = 0;
        for (var element in widget.lista.items) {
          if (element.isDone) {
            done++;
          }
          if (!element.isCategory) {
            undone++;
          }
        }
        if (undone > 0) {
          percentage = (done / undone);
        }

        // widget
        if (widget.size == CustomPercentIndicatorSize.big) {
          return CircularPercentIndicator(
            radius: 50,
            lineWidth: 10,
            percent: percentage,
            center: Text(
              '$done/$undone',
              style: style.labelLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            progressColor: Colors.cyan,
            circularStrokeCap: CircularStrokeCap.round,
          );
        }
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
