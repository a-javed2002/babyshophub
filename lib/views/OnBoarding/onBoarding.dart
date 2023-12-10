import 'package:babyshophub/views/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:babyshophub/views/OnBoarding/widgets.dart';
import 'package:babyshophub/views/home/home.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _controller = PageController();
  bool onLastPage = false;
  int page = 1;

  _setOnboardingStatus({required status}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingDone', status);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
                page = index;
              });
            },
            children: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                page == 0
                    ? ElevatedButton(
                        onPressed: () {
                          _setOnboardingStatus(status: true);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text("Skip"),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          _controller.previousPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                          );
                        },
                        child: Text("Back"),
                      ),
                onLastPage
                    ? ElevatedButton(
                        onPressed: () {
                          _setOnboardingStatus(status: true);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text("Done"),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          if (_controller.page != null &&
                              _controller.page! < 2) {
                            _controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        child: Text("Next"),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
