import 'package:flutter/material.dart';
import 'package:flutter_app/Themes/theme.dart';
import 'package:flutter_app/Widgets/appbar.dart';
import 'package:flutter_app/Widgets/bottom_nav_bar.dart';
import 'package:flutter_app/Widgets/home_dashboard.dart';
import 'package:flutter_app/Widgets/button_with_icon.dart';
import 'package:flutter_app/Scaffolds/Account/account.dart';
import 'package:flutter_app/Widgets/sidebar.dart';

class MyHomePage extends StatefulWidget {
	const MyHomePage({super.key});

	@override
	State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

	// Create a GlobalKey for the ScaffoldState
	final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

	@override
	Widget build(BuildContext context) {

		return Scaffold(
			key: _scaffoldKey,
			appBar: PreferredSize(
				preferredSize: const Size.fromHeight(55.0), // Increase AppBar height
				child: MyAppBar(sidebarState: _scaffoldKey, title: 'Home'),
			),
			drawer: const SideBar(),
			body: SingleChildScrollView(
				child: Container(
					margin: const EdgeInsets.all(16.0),
					child: Column(
						children: <Widget>[
							Container(
								margin: const EdgeInsets.only(bottom: 16.0),
								height: 450,
								decoration: BoxDecoration(
									color: primaryThemeColour,
									borderRadius: BorderRadius.circular(10.0),
								),
								child: const Center(
									child: Column(
										children: <Widget>[
											Align(
												alignment: Alignment.topCenter,
												child: Column(
													children: <Widget>[
														Padding(
															padding: EdgeInsets.all(8.0),
															child: Text(
																"Welcome Back {User}!",
																style: TextStyle(
																	fontSize: 20,
																	fontWeight: FontWeight.bold,
																	color: Colors.white,
																),
															),
														),
														Text('Dashboard', style: TextStyle(color: Colors.white),)
													],
												),
											),
											Align(
												alignment: Alignment.centerLeft,
												child: Dashboard(),
											)
										],
									),
								),
							),
							Container(
								margin: const EdgeInsets.only(bottom: 16.0),
								height: 50,
								decoration: BoxDecoration(
									color: primaryThemeColour,
									borderRadius: BorderRadius.circular(10.0),
								),
								child: Center(
									child: ButtonWithIcon(
										onClick: () {
											Navigator.push(
												context,
												MaterialPageRoute(builder: (context) => const Account()),
											);
										},
										colour: secondaryThemeColour, 
										text: 'Test'
										),
								),
							),
							// Add more containers here as needed
						],
					),
				),
			),
			bottomNavigationBar: const BottomNavBar(page: 'home'),
		);
	}
}
