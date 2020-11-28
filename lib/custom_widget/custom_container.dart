import 'package:flutter/material.dart';
import 'package:fluxstore/global/colors.dart';


/// CustomContainer() - widget with rounded borders, made in the style of the application
/// used in main screens of application

class CustomContainer extends StatelessWidget {
  final Widget child;

  const CustomContainer({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height: double.infinity),
      decoration: BoxDecoration(
        color: c_background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: child,
    );
  }
}
