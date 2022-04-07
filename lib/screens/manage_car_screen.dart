import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './add_car_screen.dart';
import './remove_car_screen.dart';
import 'package:get/get.dart';

class ManageCarScreen extends StatefulWidget {
  @override
  _ManageCarScreenState createState() => _ManageCarScreenState();
}

class _ManageCarScreenState extends State<ManageCarScreen> {
  var index = 0.obs;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.lightGreen,
          ),
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
          title: Text(
            'Manage Cars',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.lightGreen,
            onTap: (val) {},
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.car,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Add Car'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.trash,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Remove Car'),
                  ],
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AddCarScreen(),
            RemoveCarScreen(),
          ],
        ),
      ),
    );
  }
}
