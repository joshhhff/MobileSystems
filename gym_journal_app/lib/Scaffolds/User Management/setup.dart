import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_journal_app/Models/Result.dart';
import 'package:gym_journal_app/Scaffolds/home.dart';
import 'package:gym_journal_app/Services/Database/database_controller.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Widgets/button_with_icon.dart';

class SetupPage extends StatefulWidget {
    const SetupPage({super.key});

    @override
    State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
    // Create a GlobalKey for the ScaffoldState
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final _databaseController = DatabaseController();
    final _workoutCountController = TextEditingController();
    final _waterController = TextEditingController();
    final _unitController = TextEditingController();

    Future<dynamic> updateUserDetails() async {
        Result returnObj;

        try {
            // retrieve currently logged in user
            var user = await _databaseController.RetrieveUserDetails();
            var documentID = user.data.docs[0].id;  // retrieve doc id for update

            // update user details with new workout and water goals
            var data = {
                'workoutGoal': _workoutCountController.text.isNotEmpty ? int.parse(_workoutCountController.text) : 0,
                'waterGoal': _waterController.text.isNotEmpty ? double.parse(_waterController.text) : 0,
                'waterUnit': _unitController.text.isNotEmpty ? _unitController.text : 'ml',
            };

            returnObj = await _databaseController.UpdateDocument('users', documentID, data);
        } catch (e) {
            returnObj = Result(success: false, message: e.toString());
        }

        return returnObj;
    }

    @override
    Widget build(BuildContext context) {
        var dropdownValue = _unitController.text.isEmpty ? 'ml' : _unitController.text;
        return FutureBuilder(
            future: _databaseController.RetrieveUserDetails(),
            builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                        backgroundColor: Colors.grey[200], // Change the background color here
                        body: Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                color: primaryThemeColour,
                            ),
                        ),
                    );
                } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                    var fullName = '${snapshot.data?.data.docs[0]['firstName']} ${snapshot.data?.data.docs[0]['lastName']}';
                    return Scaffold(
                        key: _scaffoldKey,
                        body: Center(
                            child: Container(
                                margin: const EdgeInsets.all(16.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                        const SizedBox(height: 100),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                                const Icon(
                                                    Icons.account_circle,
                                                    size: 100,
                                                    color: primaryThemeColour,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                    'Welcome, $fullName',
                                                    style: TextStyle(
                                                        color: primaryThemeColour,
                                                        fontSize: 24.0,
                                                        fontWeight: FontWeight.bold,
                                                    ),
                                                ),
                                            ],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                            "Fine-tune your experience by setting up your workout and water goals.",
                                            style: TextStyle(
                                                color: primaryThemeColour,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                            ),
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                            controller: _workoutCountController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.digitsOnly
                                            ],
                                            decoration: const InputDecoration(
                                                labelText: 'Workout frequency per week?',
                                                border: OutlineInputBorder(),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: secondaryThemeColour),
                                                ),
                                            ),
                                            cursorColor: secondaryThemeColour,
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                            children: [
                                                Expanded(
                                                    flex: 3,
                                                    child: TextField(
                                                        controller: _waterController,
                                                        inputFormatters: <TextInputFormatter>[
                                                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                                                        ],
                                                        decoration: const InputDecoration(
                                                            labelText: 'What is your water goal per day?',
                                                            border: OutlineInputBorder(),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: secondaryThemeColour),
                                                            ),
                                                        ),
                                                        cursorColor: secondaryThemeColour,
                                                    ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                    flex: 1,
                                                    child: DropdownButtonFormField<String>(
                                                        value: dropdownValue,
                                                        dropdownColor: primaryThemeColour, // Change background color here
                                                        decoration: InputDecoration(
                                                            filled: true,
                                                            fillColor: primaryThemeColour,
                                                            border: OutlineInputBorder(),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: primaryThemeColour),
                                                            ),
                                                        ),
                                                        icon: Icon(
                                                            Icons.arrow_drop_down,
                                                            color: Colors.white, // Change the arrow icon color here
                                                        ),
                                                        onChanged: (String? newValue) {
                                                            setState(() {
                                                                dropdownValue = newValue!;
                                                                _unitController.text = newValue;
                                                            });
                                                        },
                                                        items: <String>['ml', 'litre', 'pint'].map<DropdownMenuItem<String>>((String value) {
                                                            return DropdownMenuItem<String>(
                                                                value: value,
                                                                child: Text(
                                                                    value,
                                                                    style: TextStyle(color: Colors.white),
                                                                ),
                                                            );
                                                        }).toList(),
                                                    ),
                                                ),
                                            ],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                            "You can skip these if you aren't sure, and change them in your account details later!",
                                            style: TextStyle(color: primaryThemeColour, fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                                ButtonWithIcon(
                                                    onClick: () async {
                                                        if (_workoutCountController.text.isNotEmpty || _waterController.text.isNotEmpty) {
                                                            var setDetails = await updateUserDetails();

                                                            if (setDetails.success) {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                                                                );
                                                            } else {
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) {
                                                                        return AlertDialog(
                                                                            title: const Text('Error', style: TextStyle(color: primaryThemeColour, fontWeight: FontWeight.bold)),
                                                                            content: Text('We were unable to set your preferences. You can set this up later in your account settings.', style: TextStyle(color: primaryThemeColour)),
                                                                            actions: <Widget>[
                                                                                TextButton(
                                                                                    onPressed: () {
                                                                                        Navigator.push(
                                                                                            context,
                                                                                            MaterialPageRoute(builder: (context) => const MyHomePage()),
                                                                                        );
                                                                                    },
                                                                                    child: const Text('OK', style: TextStyle(color: primaryThemeColour)),
                                                                                ),
                                                                            ],
                                                                        );
                                                                    },
                                                                );
                                                            }
                                                        } else {
                                                            // user hasn't added extra details - go straight to home page
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder: (context) => const MyHomePage()),
                                                            );
                                                        }
                                                        
                                                        // Handle login logic here
                                                        /* Result isValidUser = await checkDbForUser(_emailController.text, _passwordController.text);
                                                        
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
                                                        } */
                                                    },
                                                    colour: primaryThemeColour,
                                                    icon: Icons.login,
                                                    text: 'Get Started',
                                                    textColour: Colors.white,
                                                    borderColour: null,
                                                ),
                                            ],
                                        ),
                                    ],
                                ),
                            ),
                        ),
                    );
                }
            },
        );
    }
}
