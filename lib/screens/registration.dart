import 'package:daily_news/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _auth = FirebaseAuth.instance;
  final email = TextEditingController();
  final password = TextEditingController();
  bool viewPassword = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.responsive(14)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(context.responsive(10)),
              child: Text(
                'Sign UP',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: context.responsive(30)),
              ),
            ),
            SizedBox(
              height: context.responsive(14),
            ),
            TextFormField(
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
              validator: Validators.email('Invalid email address'),
            ),
            SizedBox(
              height: context.responsive(14),
            ),
            TextFormField(
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
              child: Container(
                child: Text('Register'),
              ),
              onPressed: () async {
                await userRegistration();
              },
            ),
            Row(
              children: [
                Text('Already registered ?'),
                TextButton(
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: context.responsive(20)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, 'login_screen');
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ),
      ),
    );
  }

  userRegistration() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      var snackBar = SnackBar(
        content: Text('Email or password is empty!'),
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (password.text.length < 6) {
      var snackBar = SnackBar(
        content: Text('Password should be minimum 6 characters!'),
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (password.text.length > 10) {
      var snackBar = SnackBar(
        content: Text('Password should not be more than 10 characters!'),
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      try {
        await _auth.createUserWithEmailAndPassword(
            email: email.text, password: password.text);
        var snackBar = SnackBar(
          content: Text('Registration Successfull'),
          duration: Duration(seconds: 3),
        );
        email.text = password.text = '';
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushNamed(context, 'home_screen');
      } catch (signUpError) {
        if (signUpError.toString().contains('is already in use')) {
          var snackBar = SnackBar(
            content: Text('User already exists!'),
            duration: Duration(seconds: 3),
          );
          email.text = password.text = '';
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (signUpError.toString().contains('invalid-email')) {
          var snackBar = SnackBar(
            content: Text('Invalid Email'),
            duration: Duration(seconds: 3),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }
  }
}
