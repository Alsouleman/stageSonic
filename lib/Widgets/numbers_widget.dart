import 'package:flutter/material.dart';

class NumbersWidget extends StatelessWidget {
  String? holder1;
  int? value1;
  String? holder2;
  int? value2;
  String? holder3;
  int? value3;
  NumbersWidget(
      {Key? key,
      this.holder1,
      this.value1,
      this.holder2,
      this.value2,
      this.holder3,
      this.value3})
      : super(key: key);

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButton(context, '$value1', '$holder1'),
            buildDivider(),
            buildButton(context, '$value2', '$holder2'),
            buildDivider(),
            buildButton(context, '$value3', '$holder3'),
          ],
        ),
      );

  Widget buildButton(BuildContext context, String s, String t) =>
      MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              s,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
            Text(
              t,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ],
        ),
      );

  Widget buildDivider() => const SizedBox(height: 24, child: VerticalDivider());
}
