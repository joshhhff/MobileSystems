import 'package:flutter/material.dart';
import 'package:flutter_app/Scaffolds/home.dart';
import 'package:flutter_app/Themes/theme.dart';
import 'package:flutter_app/Widgets/button_with_icon.dart';

class Login extends StatefulWidget {
    const Login({super.key});

    @override
    State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    bool checkDbForUser(String email, String password) {
        // Check database for user

        print('User details: $email - $password');
        return true;
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
                child: Container(
                    margin: const EdgeInsets.all(16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            const SizedBox(height: 100),
                            const Icon(
                                Icons.account_circle,
                                size: 100,
                                color: secondaryThemeColour,
                            ),
                            const SizedBox(height: 16),
                            TextField(
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
                            TextField(
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
                            ),
                            const SizedBox(height: 16),
                            ButtonWithIcon(
                                onClick: () {
                                    // Handle login logic here
                                    bool isValidUser = checkDbForUser(_emailController.text, _passwordController.text);
                                    
                                    if (isValidUser) {
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
                                                    content: const Text('Invalid email or password. Please try again.'),
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
                                colour: secondaryThemeColour,
                                icon: Icons.login,
                                text: 'Login',
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}
