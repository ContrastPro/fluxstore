import 'package:flutter/material.dart';

/// StarRating() - widget which used in CustomProductItem() and ProductScreen()
/// for displaying current rating of product

class StarRating extends StatelessWidget {
  final int starCount;
  final double size;
  final double rating;
  final Color colorPrimary;
  final Color colorSecondary;

  StarRating({
    this.starCount = 5,
    this.size,
    this.rating = .0,
    this.colorPrimary,
    this.colorSecondary,
  });

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star,
        size: size,
        color: colorSecondary ?? Theme.of(context).primaryColorLight,
      );
    } else {
      icon = Icon(
        Icons.star,
        size: size,
        color: colorPrimary ?? Theme.of(context).primaryColorDark,
      );
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        starCount,
        (index) => buildStar(context, index),
      ),
    );
  }
}
