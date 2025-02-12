import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_journal_app/Models/Result.dart';
import 'package:gym_journal_app/Scaffolds/Account/account.dart';
import 'package:gym_journal_app/Services/Authentication/Controllers/AuthenticationServices.dart';
import 'package:gym_journal_app/Services/Database/database_controller.dart';
import 'package:gym_journal_app/Themes/theme.dart';
import 'package:gym_journal_app/Widgets/appbar.dart';
import 'package:gym_journal_app/Widgets/bottom_nav_bar.dart';
import 'package:gym_journal_app/Widgets/button_with_icon.dart';
import 'package:gym_journal_app/Widgets/sidebar.dart';

class EditAccount extends StatefulWidget {
    const EditAccount({super.key});

    @override
    State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final _unitController = TextEditingController();
    final _databaseController = DatabaseController();
    final _authenticationController = AuthenticationController();

    final _firstNameController = TextEditingController();
    final _lastNameController = TextEditingController();
    final _workoutCountController = TextEditingController();
    final _waterGoalController = TextEditingController();
    final _unitPreferenceController = TextEditingController();

    Future<Result> SaveAccount() async {
        try {
            // Save account details
            var currentUser = await _authenticationController.getCurrentUser();
            var userId = currentUser!.uid;

            var newData = {
                'firstName': _firstNameController.text,
                'lastName': _lastNameController.text,
                'workoutGoal': int.parse(_workoutCountController.text),
                'waterGoal': double.parse(_waterGoalController.text),
                'waterUnit': _unitController.text == '' ? 'ml' : _unitController.text,
            };

            Result updateAccount = await _databaseController.UpdateAccount(userId, newData);

            if (updateAccount.success) {
                return Result(success: true, message: 'Account details saved successfully');
            }

            return Result(success: false, message: 'Account details not saved');
        } catch (e) {
            return Result(success: false, message: e.toString());
        }
    }

    @override
    Widget build(BuildContext context) {

        return FutureBuilder(
            future: _databaseController.RetrieveUserDetails(),
            builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            color: primaryThemeColour,
                        ),
                    );
                } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                    var userDetails = snapshot.data?.data.docs[0].data();
                    
                    String firstName = userDetails['firstName'];
                    _firstNameController.text = firstName;
                    String lastName = userDetails['lastName'];
                    _lastNameController.text = lastName;

                    String email = userDetails['email'];
                    // String workoutGoal = userDetails['workoutGoal'] != null
                    //     ? userDetails['workoutGoal'].toString()
                    //     : 'Not set';
                    
                    String workoutGoal = userDetails["workoutGoal"].toString();
                    if (workoutGoal == 'null') {
                        workoutGoal = 'Not set';
                    }
                    _workoutCountController.text = workoutGoal;

                    String waterGoal = userDetails["waterGoal"].toString();
                    if (waterGoal == 'null') {
                        waterGoal = 'Not set';
                    }
                    _waterGoalController.text = waterGoal;

                    /* String unitPreference = userDetails['waterGoal'] != null
                        ? userDetails['waterUnit']
                        : '';
                    _unitPreferenceController.text = unitPreference; */
                    String unitPreference = userDetails["waterUnit"];
                    if (unitPreference == null) {
                        unitPreference = 'ml';
                    }
                    _unitController.text = unitPreference;

                    var dropdownValue = _unitController.text;
        
                    return Scaffold(
                        key: _scaffoldKey,
                        backgroundColor: primaryThemeColour,
                        appBar: PreferredSize(
                            preferredSize: const Size.fromHeight(55.0), // Increase AppBar height
                            child: MyAppBar(sidebarState: _scaffoldKey, title: 'Edit Account'),
                        ),
                        drawer: const SideBar(),
                        body: SingleChildScrollView(
                            child: Column(
                                children: <Widget>[
                                    Container(
                                        padding: const EdgeInsets.all(25.0),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
                                        ),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                                Row(
                                                    children: [
                                                        Icon(
                                                            Icons.account_circle,
                                                            size: 100,
                                                            color: primaryThemeColour,
                                                        ),
                                                        const SizedBox(width: 10),
                                                        Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                                Text(
                                                                    '$firstName $lastName',
                                                                    style: TextStyle(
                                                                        color: primaryThemeColour,
                                                                        fontSize: 32.0,
                                                                        fontWeight: FontWeight.bold,
                                                                    ),
                                                                ),
                                                                Text(email, 
                                                                    style: TextStyle(
                                                                        color: primaryThemeColour, 
                                                                        fontSize: 18,
                                                                    )
                                                                ),
                                                            ]
                                                        )         
                                                    ]
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                    children: [
                                                        ButtonWithIcon(text: 'Save', icon: Icons.save, textColour: Colors.white, colour: primaryThemeColour, onClick: () async {
                                                            showDialog(
                                                                context: context,
                                                                builder: (BuildContext context) {
                                                                    return AlertDialog(
                                                                        title: const Text('Confirm'),
                                                                        content: const Text('Are you sure you want to save these changes?'),
                                                                        actions: <Widget>[
                                                                            TextButton(
                                                                                onPressed: () {
                                                                                    Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(builder: (context) => const Account()),
                                                                                    );
                                                                                },
                                                                                child: const Text('Cancel'),
                                                                            ),
                                                                            TextButton(
                                                                                onPressed: () async {
                                                                                    await SaveAccount();

                                                                                    Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(builder: (context) => const Account()),
                                                                                    );
                                                                                },
                                                                                child: const Text('Save'),
                                                                            ),
                                                                        ],
                                                                    );
                                                                },
                                                            );
                                                        }),
                                                        const SizedBox(width: 10),
                                                        ButtonWithIcon(text: 'Cancel', icon: Icons.cancel, textColour: Colors.white, colour: tertiaryThemeColour, onClick:()  {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder: (context) => const Account()),
                                                            );
                                                        })
                                                    ]
                                                ),
                                                // Add more content here
                                            ],
                                        ),
                                    ),
                                    Container(
                                        constraints: BoxConstraints(
                                            minHeight: 0,
                                            maxHeight: double.infinity,
                                        ),
                                        decoration: BoxDecoration(
                                            color: primaryThemeColour,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0)),
                                        ),
                                        child: Center(
                                            child: Column(
                                                children: <Widget>[
                                                    Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Column(
                                                            children: <Widget>[
                                                                Padding(
                                                                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                                                                    child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(
                                                                            'Name',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 28.0,
                                                                                color: Colors.white,
                                                                            ),
                                                                        ),
                                                                    ),
                                                                ),
                                                                Padding(
                                                                    padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                                                                    child: Column(
                                                                        children: [
                                                                            Row(
                                                                                children: [
                                                                                    Expanded(
                                                                                        flex: 1,
                                                                                        child: Text(
                                                                                            'First Name',
                                                                                            style: TextStyle(
                                                                                                color: Colors.white,
                                                                                                fontSize: 18.0,
                                                                                            ),
                                                                                        )
                                                                                    ),
                                                                                    Expanded(
                                                                                        flex: 2,
                                                                                        child: TextField(
                                                                                            keyboardType: TextInputType.emailAddress,
                                                                                            controller: _firstNameController,
                                                                                            decoration: const InputDecoration(
                                                                                                filled: true,
                                                                                                fillColor: Colors.white,
                                                                                                border: OutlineInputBorder(
                                                                                                    borderSide: BorderSide(color: primaryThemeColour),
                                                                                                ),
                                                                                                
                                                                                            ),
                                                                                            cursorColor: Colors.black,
                                                                                        ),
                                                                                    ),
                                                                                ]
                                                                            ),
                                                                            const SizedBox(height: 10),
                                                                            Row(
                                                                                children: [
                                                                                    Expanded(
                                                                                        flex: 1,
                                                                                        child: Text(
                                                                                            'Last Name',
                                                                                            style: TextStyle(
                                                                                                color: Colors.white,
                                                                                                fontSize: 18.0,
                                                                                            ),
                                                                                        )
                                                                                    ),
                                                                                    Expanded(
                                                                                        flex: 2,
                                                                                        child: TextField(
                                                                                            keyboardType: TextInputType.emailAddress,
                                                                                            controller: _lastNameController,
                                                                                            decoration: const InputDecoration(
                                                                                                filled: true,
                                                                                                fillColor: Colors.white,
                                                                                                border: OutlineInputBorder(
                                                                                                    borderSide: BorderSide(color: primaryThemeColour),
                                                                                                ),
                                                                                                
                                                                                            ),
                                                                                            cursorColor: Colors.black,
                                                                                        ),
                                                                                    ),
                                                                            ],)
                                                                            
                                                                        ],
                                                                    ),
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.all(25.0),
                                                                    child: Divider(
                                                                        color: Colors.white,
                                                                        thickness: 1.0,
                                                                    ),
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
                                                                    child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(
                                                                            'Goals',
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 28.0,
                                                                                color: Colors.white,
                                                                            ),
                                                                        ),
                                                                    ),
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
                                                                    child: Row(
                                                                        children: [
                                                                            Expanded(
                                                                                flex: 4,
                                                                                child: Text(
                                                                                    'Workout frequency per week',
                                                                                    style: TextStyle(
                                                                                        color: Colors.white,
                                                                                        fontSize: 18.0,
                                                                                    ),
                                                                                )
                                                                            ),
                                                                            Expanded(
                                                                                flex: 1,
                                                                                child: TextField(
                                                                                    textAlign: TextAlign.center,
                                                                                    controller: _workoutCountController,
                                                                                    keyboardType: TextInputType.number,
                                                                                    inputFormatters: <TextInputFormatter>[
                                                                                        FilteringTextInputFormatter.digitsOnly
                                                                                    ],
                                                                                    decoration: const InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        border: OutlineInputBorder(
                                                                                            borderSide: BorderSide(color: primaryThemeColour)
                                                                                        ),
                                                                                    ),
                                                                                    cursorColor: Colors.black,
                                                                                ),
                                                                            )
                                                                        ],
                                                                    )
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.symmetric(horizontal: 25),
                                                                    child: Row(
                                                                        children: [
                                                                            Expanded(
                                                                                flex: 2,
                                                                                child: Text(
                                                                                    'Water goal per day',
                                                                                    style: TextStyle(
                                                                                        color: Colors.white,
                                                                                        fontSize: 18.0,
                                                                                    ),
                                                                                )
                                                                            ),
                                                                            Expanded(
                                                                                flex: 1,
                                                                                child: TextField(
                                                                                    textAlign: TextAlign.center,
                                                                                    controller: _waterGoalController,
                                                                                    inputFormatters: <TextInputFormatter>[
                                                                                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                                                                                    ],
                                                                                    decoration: const InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        border: OutlineInputBorder(
                                                                                            borderSide: BorderSide(color: primaryThemeColour)
                                                                                        ),
                                                                                        
                                                                                    ),
                                                                                    cursorColor: Colors.black,
                                                                                ),
                                                                            ),
                                                                            const SizedBox(width: 10),
                                                                            Expanded(
                                                                                flex: 1,
                                                                                child: DropdownButtonFormField<String>(
                                                                                    value: dropdownValue,
                                                                                    dropdownColor: Colors.white, // Change background color here
                                                                                    decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.white,
                                                                                        border: OutlineInputBorder(
                                                                                            borderSide: BorderSide(color: primaryThemeColour)
                                                                                        ),
                                                                                        
                                                                                    ),
                                                                                    icon: Icon(
                                                                                        Icons.arrow_drop_down,
                                                                                        color: Colors.black, // Change the arrow icon color here
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
                                                                                                style: TextStyle(color: Colors.black),
                                                                                            ),
                                                                                        );
                                                                                    }).toList(),
                                                                                ),
                                                                            ),
                                                                    ])
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0, top: 30),
                                                                    child: Divider(
                                                                        color: Colors.white,
                                                                        thickness: 1.0,
                                                                    ),
                                                                ),
                                                              ],
                                                              
                                                        ),
                                                    ),
                                                ],
                                            ),
                                        ),
                                    )
                                    // Add more containers here as needed
                                ],
                            ),
                        ),
                        bottomNavigationBar: const BottomNavBar(page: 'account'),
                    );
                }
            }
        );
    }
}
