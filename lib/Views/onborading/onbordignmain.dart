import 'package:flutter/material.dart';

import 'onboarding_first.dart';

class OnBordingMain extends StatefulWidget {
  const OnBordingMain({super.key});

  @override
  State<OnBordingMain> createState() => _OnBordingMainState();
}

class _OnBordingMainState extends State<OnBordingMain> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(), // Disable swipe
        children: <Widget>[
          OnbordingScreen_one(
            controller: _controller,
            pagenumber: 1,
            totalpages: 3,
            heading: "Heading 1",
            description: "This is the first page",
            image_route: 'assets/Onboarding1.png',
          ),
          OnbordingScreen_one(
            controller: _controller,
            pagenumber: 2,
            totalpages: 3,
            heading: "Heading 2",
            description: "This is the second page",
            image_route: 'assets/Onboarding2.png',
          ),
          OnbordingScreen_one(
            controller: _controller,
            pagenumber: 3,
            totalpages: 3,
            heading: "Heading 3",
            description: "This is the third page",
            image_route: 'assets/Onboarding3.png',
          ),
        ],
      ),
    );
  }
}
