import 'package:daily_news/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  final email = TextEditingController();
  final password = TextEditingController();
  bool viewPassword = true;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to Exit the Application?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.responsive(14)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(context.responsive(10)),
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: context.responsive(30)),
                ),
              ),
              SizedBox(
                height: context.responsive(14),
              ),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: context.responsive(14)),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  labelText: 'Email',
                ),
              ),
              SizedBox(
                height: context.responsive(14),
              ),
              TextField(
                obscureText: viewPassword,
                controller: password,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: context.responsive(14)),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  labelText: 'Password',
                  suffix: GestureDetector(
                    child: viewPassword
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onTap: () {
                      setState(() {
                        viewPassword = !viewPassword;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: context.responsive(14),
              ),
              ElevatedButton(
                  child: Text('Login'),
                  onPressed: () async {
                    loginUser();
                  }),
              Row(
                children: [
                  Text('Haven\'t registered yet ?'),
                  TextButton(
                    child: Text(
                      'Sign UP',
                      style: TextStyle(fontSize: context.responsive(20)),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'registration_screen');
                    },
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  loginUser() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      var snackBar = SnackBar(
        content: Text('Email or password is empty!'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email.text, password: password.text);
        Navigator.pushNamed(context, 'home_screen');
      } catch (error) {
        var snackBar = SnackBar(
          content: Text('The password is invalid or the user does not exist!'),
          duration: Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}
