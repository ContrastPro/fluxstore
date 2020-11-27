import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final int index;
  final int progressCount;
  final double width;
  final double height;
  final Color colorPrimary;
  final Color colorSecondary;

  CustomProgressIndicator({
    this.index,
    this.progressCount = 5,
    this.width,
    this.height,
    this.colorPrimary,
    this.colorSecondary,
  });

  Widget buildProgressIndicator(BuildContext context, int i) {
    Widget progressIndicator;

    if (index <= i - 1) {
      progressIndicator = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          width: width ?? 25.0,
          height: height ?? 2.0,
          decoration: BoxDecoration(
            color: colorSecondary ?? Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.all(Radius.circular(45)),
          ),
        ),
      );
    } else {
      progressIndicator = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          width: width ?? 25.0,
          height: height ?? 2.0,
          decoration: BoxDecoration(
            color: colorPrimary ?? Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.all(Radius.circular(45)),
          ),
        ),
      );
    }
    return progressIndicator;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        progressCount,
        (index) => buildProgressIndicator(context, index),
      ),
    );
  }
}
