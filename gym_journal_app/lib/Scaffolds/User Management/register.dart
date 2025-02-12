import 'package:flutter/material.dart';
import 'package:gym_journal_app/Scaffolds/User%20Management/setup.dart';
import 'package:gym_journal_app/Scaffolds/home.dart';
import 'package:gym_journal_app/Scaffolds/User%20Management/login.dart';
import 'package:gym_journal_app/Models/Result.dart';
import 'package:gym_journal_app/Services/Authentication/Controllers/AuthenticationServices.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Utilities/WavePainter.dart';
import 'package:gym_journal_app/Widgets/button_with_icon.dart';

class Register extends StatefulWidget {
    const Register({super.key});

    @override
    State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
    double titleController = 80;
    double heightController = 300;
    final _firstNameController = TextEditingController();
    final _lastNameController = TextEditingController();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _authenticationController = AuthenticationController();

    Future<Result> CreateUser(String email, String password, String forename, String surname) async {
        // Check database for user
        Result isValidUser = await _authenticationController.RegisterUser(email, password, forename, surname);
        return isValidUser;
    }
    
    void Registration() async {
        Result registerUser = await CreateUser(
            _emailController.text,
            _passwordController.text,
            _firstNameController.text,
            _lastNameController.text,
        );

        if (registerUser.success) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SetupPage()),
            );
        } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                    return AlertDialog(
                        title: const Text('Sign up failed'),
                        content: Text(registerUser.message),
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
                        child: Column(
                            children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                        icon: const Icon(Icons.arrow_back, size: 50, color: Colors.white),
                                        onPressed: () {
                                           Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const Login()),
                                            );
                                        },
                                    ),
                                ),
                                Row(
                                    children: [
                                        const Icon(
                                            Icons.account_circle,
                                            size: 100,
                                            color: Colors.white,
                                        ),
                                        const SizedBox(width: 16),
                                        Text('Sign up', style: TextStyle(color: Colors.white, fontSize: 50)),
                                    ],
                                ),
                            ],
                        ),
                    ),
                    Center(
                        child: Container(
                            margin: const EdgeInsets.all(16.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                    SizedBox(height: heightController),
                                    TextField(
                                        controller: _firstNameController,
                                        decoration: const InputDecoration(
                                            labelText: 'First Name',
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: secondaryThemeColour),
                                            ),
                                        ),
                                        cursorColor: secondaryThemeColour,
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                        controller: _lastNameController,
                                        decoration: const InputDecoration(
                                            labelText: 'Last Name',
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: secondaryThemeColour),
                                            ),
                                        ),
                                        cursorColor: secondaryThemeColour,
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
                                    Focus(
                                        onFocusChange: (hasFocus) {
                                            setState(() {
                                                titleController = hasFocus ? 40 : 80;
                                                heightController = hasFocus ? 200 : 300;
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
                                        ),
                                    ),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                        width: double.infinity,
                                        child: ButtonWithIcon(
                                            onClick: () async {
                                                // Handle login logic here
                                                Registration();
                                            },
                                            colour: primaryThemeColour,
                                            icon: Icons.login,
                                            text: 'Sign up',
                                            textColour: Colors.white,
                                            borderColour: null,
                                        ),
                                    ),
                                    if (titleController == 80) const SizedBox(height: 16),
                                    if (titleController == 80)
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
                                    if (titleController == 80)  SizedBox(height: 16),
                                    if (titleController == 80) SizedBox(
                                        width: double.infinity,
                                        child: ButtonWithIcon(
                                            onClick: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const Login()),
                                                );
                                            },
                                            colour: Colors.white,
                                            icon: Icons.arrow_back,
                                            text: 'Login',
                                            textColour: tertiaryThemeColour,
                                            borderColour: tertiaryThemeColour,
                                        ),
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