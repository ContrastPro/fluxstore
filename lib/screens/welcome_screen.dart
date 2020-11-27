import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluxstore/custom_widget/custom_fade_route.dart';
import 'package:fluxstore/custom_widget/custom_progress_indicator.dart';
import 'package:fluxstore/global/colors.dart';
import 'package:fluxstore/screens/home_screen.dart';
import 'package:fluxstore/screens/sign_in_up_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  _goToSignInUpScreen({bool signIn}) {
    Navigator.push(
      context,
      FadeRoute(
        page: SignInUpScreen(signIn: signIn),
      ),
    );
  }

  _goToHomeScreen() {
    Navigator.push(
      context,
      FadeRoute(
        page: HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _pageItem(String icon, Widget title, String description) {
      return Column(
        children: [
          Expanded(
            child: Image.asset(
              'assets/welcome/$icon.png',
              fit: BoxFit.contain,
            ),
          ),
          title,
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: t_secondary,
              ),
            ),
          ),
        ],
      );
    }

    Widget _widgetSignInUp() {
      TextStyle textStyle = TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w300,
        color: c_primary,
      );

      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          FlatButton(
            child: Text(
              'Sign In',
              style: textStyle,
            ),
            onPressed: () => _goToSignInUpScreen(signIn: true),
          ),
          Container(width: 0.5, height: 15, color: Colors.black),
          FlatButton(
            child: Text(
              'Sign Up',
              style: textStyle,
            ),
            onPressed: () => _goToSignInUpScreen(signIn: false),
          )
        ],
      );
    }

    Widget _welcomeScreen() {
      TextStyle textStyle = TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w300,
        color: t_primary,
      );

      return Column(
        children: [
          Expanded(
            flex: 80,
            child: PageView(
              physics: BouncingScrollPhysics(),
              onPageChanged: (int i) {
                setState(() => _pageIndex = i);
              },
              children: [
                _pageItem(
                  "1",
                  Text("Welcome to Fluxstore", style: textStyle),
                  "Lorem Ipsum Dolor Sit Amet Consectetur Adipisicing Elit",
                ),
                _pageItem(
                  "2",
                  Text("Lorconsectetur adipisicing", style: textStyle),
                  "Lorem Ipsum Dolor Sit Amet Consectetur Adipisicing Elit",
                ),
                _pageItem(
                  "3",
                  _widgetSignInUp(),
                  "Lorem Ipsum Dolor Sit Amet Consectetur Adipisicing Elit",
                ),
              ],
            ),
          ),
          Expanded(
            flex: 20,
            child: Row(
              children: [
                Expanded(child: SizedBox()),
                CustomProgressIndicator(
                  index: _pageIndex,
                  width: 25,
                  height: 2,
                  progressCount: 3,
                  colorPrimary: Colors.black,
                  colorSecondary: Colors.black12,
                ),
                Expanded(
                  child: _pageIndex == 2
                      ? ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: [
                            FlatButton.icon(
                              onPressed: () => _goToHomeScreen(),
                              icon: Text(
                                "Skip",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: c_primary,
                                ),
                              ),
                              label: Icon(
                                Icons.arrow_forward_ios,
                                size: 10,
                                color: c_primary,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: c_background,
      body: SafeArea(child: _welcomeScreen()),
    );
  }
}
