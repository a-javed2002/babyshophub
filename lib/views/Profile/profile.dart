import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

        _setOnboardingStatus({required status}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingDone', status);
    print("set OnBoarding To False");
  }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {},
          child: Icon(Icons.group_add, size: screenWidth * 0.07),
        ),
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text("View Profile",
              style: TextStyle(fontSize: screenWidth * 0.04)),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _setOnboardingStatus(status: false);
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: screenWidth * 0.06,
                        ),
                        child: Text(
                          "Julianna Carter",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.05),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenWidth * 0.02,
                        ),
                        child: Text(
                          "Photographer",
                          style: TextStyle(
                              color: Colors.grey, fontSize: screenWidth * 0.03),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.message,
                        color: Colors.green, size: screenWidth * 0.06),
                    CircleAvatar(
                      radius: screenWidth * 0.1,
                      backgroundImage: AssetImage(
                        "assets/images/profile.jpg",
                      ),
                      backgroundColor: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.purple,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    Icon(Icons.call,
                        color: Colors.green, size: screenWidth * 0.06),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "1.5 K",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: screenWidth * 0.04),
                        ),
                        Text(
                          "Posts",
                          style: TextStyle(
                              color: Colors.grey, fontSize: screenWidth * 0.03),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "17.8 K",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: screenWidth * 0.04),
                        ),
                        Text(
                          "Followers",
                          style: TextStyle(
                              color: Colors.grey, fontSize: screenWidth * 0.03),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "1.3 K",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: screenWidth * 0.04),
                        ),
                        Text(
                          "Following",
                          style: TextStyle(
                              color: Colors.grey, fontSize: screenWidth * 0.03),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Website",
                                style: TextStyle(
                                    color: Colors.purple,
                                    fontSize: screenWidth * 0.04),
                              ),
                              Text(
                                "visual.photo.me",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenWidth * 0.03),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 130,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontSize: screenWidth * 0.04),
                                ),
                                Text(
                                  "juliana.o@mail.com",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: screenWidth * 0.03),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Phone",
                                style: TextStyle(
                                    color: Colors.purple,
                                    fontSize: screenWidth * 0.04),
                              ),
                              Text(
                                "(022)77723287",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenWidth * 0.03),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 130,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Location",
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontSize: screenWidth * 0.04),
                                ),
                                Text(
                                  "United State",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: screenWidth * 0.03),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Zip Code",
                                style: TextStyle(
                                    color: Colors.purple,
                                    fontSize: screenWidth * 0.04),
                              ),
                              Text(
                                "6525",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenWidth * 0.03),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 130,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Address",
                                  style: TextStyle(
                                      color: Colors.purple,
                                      fontSize: screenWidth * 0.04),
                                ),
                                Text(
                                  "160th St, Fresh Meadows NY 11365",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: screenWidth * 0.03),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
