import 'package:flutter/material.dart';
import 'package:flutter_app/Widgets/appbar.dart';
import 'package:flutter_app/Widgets/bottom_nav_bar.dart';
import 'package:flutter_app/Widgets/sidebar.dart';

class Entries extends StatefulWidget {
  const Entries({super.key});

  @override
  State<Entries> createState() => _EntriesState();
}

class _EntriesState extends State<Entries> {
	final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  	@override
  	Widget build(BuildContext context) {
		return Scaffold(
		  key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(55.0), // Increase AppBar height
        child: MyAppBar(sidebarState: _scaffoldKey, title: 'Entries'),
      ),
      drawer: const SideBar(),
      body: const Center(
        child: Text(
          "Entries Page",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(page: 'logs'),
    	);
  	}
}