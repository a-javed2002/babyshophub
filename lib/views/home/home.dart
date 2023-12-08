import 'package:babyshophub/views/authentication/Login.dart';
import 'package:babyshophub/views/common/drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService authService = AuthService();



  Future<void> _logout(BuildContext context) async {
    try {
      await _auth.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print('Error during logout: $e');
      // Handle logout errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600), // Adjust as needed
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(context),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return _buildTile(context, index);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _logout(context);
        },
        tooltip: 'Logout',
        child: Icon(Icons.logout),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return 1; // Single column for smaller screens
    } else {
      return 2; // Two columns for larger screens
    }
  }

  Widget _buildTile(BuildContext context, int index) {
    List<String> titles = ["Create Bid", "View Bids", "View Requests", "Settings"];
    List<IconData> icons = [Icons.add, Icons.list, Icons.person, Icons.settings];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          _handleTileClick(context, index);
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icons[index],
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 8),
              Text(
                titles[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTileClick(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        break;
      case 3:
        // Add navigation to the settings page
        break;
    }
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Check if the user is logged in
  Future<bool> isLoggedIn() async {
    User? user = _auth.currentUser;
    return user != null;
  }
}
