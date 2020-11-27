import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluxstore/api/authentication_api.dart';
import 'package:fluxstore/custom_widget/custom_container.dart';
import 'package:fluxstore/global/colors.dart';
import 'package:provider/provider.dart';

class SignInUpScreen extends StatefulWidget {
  final bool signIn;

  const SignInUpScreen({Key key, this.signIn}) : super(key: key);

  @override
  _SignInUpScreenState createState() => _SignInUpScreenState();
}

class _SignInUpScreenState extends State<SignInUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  bool _signIn;
  bool _obscurePassword = true, _obscurePasswordConfirm = true;
  bool _enter = false;
  User _user = User();

  @override
  void initState() {
    _signIn = widget.signIn;
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier);
    super.initState();
  }

  _signInUser(User user, AuthNotifier authNotifier) async {
    AuthResult authResult = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: user.email.trim(), password: user.password.trim())
        .catchError((error) {
      print(error.code);
      setState(() => _enter = !_enter);
      _showErrorSignIn(error.code);
    });

    if (authResult != null) {
      FirebaseUser firebaseUser = authResult.user;

      if (firebaseUser != null) {
        _passwordController.clear();
        setState(() => _enter = !_enter);
        print("Sign In: $firebaseUser");
        authNotifier.setUser(firebaseUser);
      }
    }
  }

  _signUpUser(User user, AuthNotifier authNotifier) async {
    AuthResult authResult = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: user.email.trim(), password: user.password.trim())
        .catchError((error) {
      print(error.code);
      setState(() => _enter = !_enter);
      _showErrorSignUp();
    });

    if (authResult != null) {
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = user.displayName.trim();

      FirebaseUser firebaseUser = authResult.user;

      if (firebaseUser != null) {
        await firebaseUser.updateProfile(updateInfo);
        await firebaseUser.reload();

        _passwordController.clear();
        setState(() => _enter = !_enter);
        print("Sign Up: $firebaseUser");

        FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
        authNotifier.setUser(currentUser);
      }
    }
  }

  _showErrorSignIn(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Error'),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
          children: <Widget>[
            Text(
              error == 'ERROR_WRONG_PASSWORD'
                  ? 'Invalid Email or Password. Check if the entry is correct.'
                  : 'An account with this Email does not exist yet. Try to Sign Up',
              style: TextStyle(fontSize: 16),
            ),
          ],
        );
      },
    );
  }

  _showErrorSignUp() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Error'),
          contentPadding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
          children: <Widget>[
            Text(
              'This Email is already in use. Try to Sign In.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        );
      },
    );
  }

  _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    setState(() => _enter = !_enter);
    if (_signIn == true) {
      _signInUser(_user, authNotifier);
    } else {
      _signUpUser(_user, authNotifier);
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);

    Widget _buildDisplayNameField() {
      return TextFormField(
        decoration: InputDecoration(
          labelText: 'Your name',
          labelStyle: TextStyle(color: Colors.black54),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
          ),
        ),
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 18, color: t_primary),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Name is required';
          }

          if (value.length < 2 || value.length > 30) {
            return 'Name cannot be shorter than 2 characters';
          }

          return null;
        },
        onChanged: (String value) {
          _user.displayName = value;
        },
      );
    }

    Widget _buildEmailField() {
      return TextFormField(
        decoration: InputDecoration(
          labelText: "Email",
          labelStyle: TextStyle(color: Colors.black54),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(fontSize: 18, color: t_primary),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Email is required';
          }

          if (!RegExp(
                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
              .hasMatch(value)) {
            return 'Please enter your Email correctly';
          }

          return null;
        },
        onChanged: (String value) {
          _user.email = value;
        },
      );
    }

    Widget _buildPasswordField() {
      return TextFormField(
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(color: Colors.black54),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
            icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off),
          ),
        ),
        style: TextStyle(fontSize: 18, color: t_primary),
        obscureText: _obscurePassword,
        controller: _passwordController,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Password is required';
          }

          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }

          return null;
        },
        onChanged: (String value) {
          _user.password = value;
        },
      );
    }

    Widget _buildConfirmPasswordField() {
      return TextFormField(
        decoration: InputDecoration(
          labelText: "Confirm the password",
          labelStyle: TextStyle(color: Colors.black54),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(
                  () => _obscurePasswordConfirm = !_obscurePasswordConfirm);
            },
            icon: Icon(_obscurePasswordConfirm
                ? Icons.visibility
                : Icons.visibility_off),
          ),
        ),
        style: TextStyle(fontSize: 18, color: t_primary),
        obscureText: _obscurePasswordConfirm,
        validator: (String value) {
          if (_passwordController.text != value) {
            return 'Passwords do not match';
          }

          return null;
        },
      );
    }

    Widget _signInUpScreen() {
      return Stack(
        children: [
          CustomContainer(
            child: Form(
              autovalidate: true,
              key: _formKey,
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(42.0, 35.0, 42.0, 42.0),
                children: <Widget>[
                  _signIn != true ? _buildDisplayNameField() : SizedBox(),
                  _buildEmailField(),
                  _buildPasswordField(),
                  _signIn != true ? _buildConfirmPasswordField() : Container(),
                  SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: FlatButton.icon(
                          onPressed: () => _submitForm(),
                          color: c_primary,
                          icon: Text(
                            _signIn != true ? 'SIGN UP' : 'SIGN IN',
                            style: TextStyle(color: Colors.white),
                          ),
                          label: Icon(
                            _signIn != true ? Icons.person_add : Icons.person,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 42),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _signIn != true
                            ? 'Already have an account?'
                            : 'Don\'t have an account?',
                        style: TextStyle(
                          color: t_primary,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () => setState(() => _signIn = !_signIn),
                        child: Text(
                          _signIn != true ? 'SignIn' : 'SignUp',
                          style: TextStyle(
                            color: c_primary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    Widget _profileScreen() {
      TextStyle textStyle = TextStyle(
        fontSize: 18,
      );

      return Stack(
        children: [
          CustomContainer(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(42.0, 35.0, 42.0, 42.0),
              children: [
                Text(
                  "Welcome, ${authNotifier.user.displayName}",
                  style: textStyle,
                ),
                Text(
                  "Your email is: ${authNotifier.user.email}",
                  style: textStyle,
                ),
                SizedBox(height: 82),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Text('Sign out of account'),
                      color: Colors.red[900],
                      onPressed: () {
                        signOut(authNotifier);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget _customAppBar({String title}) {
      return AppBar(
        backgroundColor: c_primary,
        elevation: 0,
        title: Text(title),
      );
    }

    return Consumer<AuthNotifier>(
      builder: (context, notifier, child) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: c_primary,
              appBar: _customAppBar(
                  title: notifier.user != null
                      ? 'Profile'
                      : _signIn != true ? 'Sign Up' : 'Sign In'),
              body:
                  notifier.user != null ? _profileScreen() : _signInUpScreen(),
            ),
            _enter == true
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black54,
                    child: SpinKitWave(
                      color: Colors.white,
                      size: 50.0,
                    ),
                  )
                : SizedBox(),
          ],
        );
      },
    );
  }
}
