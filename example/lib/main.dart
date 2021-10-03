import 'package:flutter/material.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // a variable to store the current selected tab. can be used to control PageView
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context).copyWith(
        // primaryColor: Colors.deepPurple[400],
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
        ),
      ),
      home: Scaffold(
        body: Center(
          child: Text(
            'Selected Tab: $_selectedIndex',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        // backgroundColor: Colors.deepPurple[400],
        // you can use the molten bar in the scaffold's bottomNavigationBar
        bottomNavigationBar: MoltenBottomNavigationBar(
          selectedIndex: _selectedIndex,
          domeHeight: 25,
          // specify what will happen when a tab is clicked
          onTabChange: (clickedIndex) {
            setState(() {
              _selectedIndex = clickedIndex;
            });
          },
          // ansert as many tabs as you like
          tabs: [
            MoltenTab(
              icon: Icon(Icons.search),

              // selectedColor: Colors.yellow,
            ),
            MoltenTab(
              icon: Icon(Icons.home),
              title: Text('home'),
              // selectedColor: Colors.yellow,
            ),
            MoltenTab(
              icon: Icon(Icons.person),
              // selectedColor: Colors.yellow,
            ),
          ],
        ),
      ),
    );
  }
}
