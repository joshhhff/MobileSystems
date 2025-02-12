import 'package:flutter/material.dart';
import 'package:gym_journal_app/Scaffolds/home.dart';
import 'package:gym_journal_app/Scaffolds/User%20Management/register.dart'; // Import the register page
import 'package:gym_journal_app/Models/Result.dart';
import 'package:gym_journal_app/Services/Authentication/Controllers/AuthenticationServices.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Utilities/WavePainter.dart';
import 'package:gym_journal_app/Widgets/button_with_icon.dart';

class Login extends StatefulWidget {
    const Login({super.key});

    @override
    State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
    double titleController = 120;
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _authenticationController = AuthenticationController();

    Future<Result> checkDbForUser(String email, String password) async {
        // Check database for user
        Result isValidUser = await _authenticationController.Login(email, password);
        return isValidUser;
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Stack(
                children: [
                    CustomPaint(
                        size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
                        painter: WavePainter(waveHeightFactor: 0.3),
                    ),
                    AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        top: titleController,
                        left: 16,
                        right: 16,
                        child: Row(
                            children: [
                                const Icon(
                                    Icons.account_circle,
                                    size: 100,
                                    color: Colors.white,
                                ),
                                const SizedBox(width: 16),
                                Text('Login', style: TextStyle(color: Colors.white, fontSize: 50)),
                            ],
                        ),
                    ),
                    Center(
                        child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(16.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                    SizedBox(height: 200),
                                    TextField(
                                        keyboardType: TextInputType.emailAddress,
                                        controller: _emailController,
                                        decoration: const InputDecoration(
                                            labelText: 'Email',
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: secondaryThemeColour),
                                            ),
                                        ),
                                        cursorColor: secondaryThemeColour,
                                    ),
                                    const SizedBox(height: 16),
                                    Focus(
                                        onFocusChange: (hasFocus) {
                                            setState(() {
                                                titleController = hasFocus ? 60 : 120;
                                            });
                                        },
                                        child: TextField(
                                            controller: _passwordController,
                                            decoration: const InputDecoration(
                                                labelText: 'Password',
                                                border: OutlineInputBorder(),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: secondaryThemeColour),
                                                ),
                                            ),
                                            obscureText: true,
                                            cursorColor: secondaryThemeColour,
                                        )
                                    ),
                                    const SizedBox(height: 8),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Text('Forgot Password?', style: TextStyle(color: primaryThemeColour, fontWeight: FontWeight.bold, fontSize: 18)),
                                    ),
                                    const SizedBox(height: 16),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                            ButtonWithIcon(
                                                onClick: () async {
                                                    // Handle login logic here
                                                    Result isValidUser = await checkDbForUser(_emailController.text, _passwordController.text);
                                                    if (isValidUser.success) {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => const MyHomePage()),
                                                        );
                                                    } else {
                                                        showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                    title: const Text('Login Failed'),
                                                                    content: Text(isValidUser.message),
                                                                    actions: <Widget>[
                                                                        TextButton(
                                                                            onPressed: () {
                                                                                Navigator.of(context).pop();
                                                                            },
                                                                            child: const Text('OK'),
                                                                        ),
                                                                    ],
                                                                );
                                                            },
                                                        );
                                                    }
                                                },
                                                colour: primaryThemeColour,
                                                icon: Icons.login,
                                                text: 'Login',
                                                textColour: Colors.white,
                                                borderColour: null,
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                                children: <Widget>[
                                                    Expanded(
                                                        child: Divider(color: tertiaryThemeColour),
                                                    ),
                                                    Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                        child: Text('OR', style: TextStyle(color: tertiaryThemeColour)),
                                                    ),
                                                    Expanded(
                                                        child: Divider(color: Colors.grey),
                                                    ),
                                                ],
                                            ),
                                            const SizedBox(height: 16),
                                            ButtonWithIcon(
                                                onClick: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => const Register()),
                                                    );
                                                },
                                                colour: Colors.white,
                                                icon: Icons.app_registration,
                                                text: 'Sign up',
                                                textColour: tertiaryThemeColour,
                                                borderColour: tertiaryThemeColour,
                                            ),
                                        ],
                                    ),
                                ],
                            ),
                        ),
                    ),
                ],
            ),
        );
    }
}
