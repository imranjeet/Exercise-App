import 'dart:convert';

import 'package:exercise_app/misc/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'workout_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List info = [];

  _initData() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/info.json")
        .then((value) {
      setState(() {
        info = json.decode(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.homePageBackground,
      body: Container(
          padding: const EdgeInsets.only(left: 20, top: 60, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Training',
                    style: TextStyle(
                        color: AppColor.homePageTitle,
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                  ),
                  Expanded(child: Container()),
                  Icon(Icons.arrow_back_ios,
                      size: 20, color: AppColor.homePageIcons),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.calendar_today_outlined,
                      size: 20, color: AppColor.homePageIcons),
                  const SizedBox(
                    width: 15,
                  ),
                  Icon(Icons.arrow_forward_ios,
                      size: 20, color: AppColor.homePageIcons),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Your program',
                    style: TextStyle(
                        color: AppColor.homePageSubtitle,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  Expanded(child: Container()),
                  Text(
                    'Details',
                    style: TextStyle(
                        color: AppColor.homePageDetail,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => const WorkoutScreen());
                    },
                    child: Icon(Icons.arrow_forward,
                        size: 20, color: AppColor.homePageIcons),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              _homeCard(size),
              const SizedBox(
                height: 5,
              ),
              _homeSecondCard(size),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "Area of focus",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: AppColor.homePageTitle),
                  ),
                ],
              ),
              Expanded(
                  child: _gridView()),
            ],
          )),
    );
  }

  Container _homeSecondCard(Size size) {
    return Container(
              height: 160,
              width: size.width,
              child: Stack(children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  height: 120,
                  width: size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                          image: AssetImage("assets/card.jpg"),
                          fit: BoxFit.fill),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(8, 10),
                          blurRadius: 40,
                          color: AppColor.gradientSecond.withOpacity(0.3),
                        ),
                        BoxShadow(
                          offset: const Offset(-1, -5),
                          blurRadius: 10,
                          color: AppColor.gradientSecond.withOpacity(0.3),
                        ),
                      ]),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 160,
                    bottom: 10,
                    left: 20,
                  ),
                  width: size.width,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                        image: AssetImage("assets/figure.png"),
                        fit: BoxFit.fill),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  height: 100,
                  margin: const EdgeInsets.only(left: 130, top: 50),
                  // color: Colors.red.withOpacity(0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your are doing great",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColor.homePageDetail),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                            text: "keep it up\n",
                            style: TextStyle(
                              color: AppColor.homePagePlanColor,
                              fontSize: 16,
                            ),
                            children: const [
                              TextSpan(
                                text: "stick to your plan",
                              )
                            ]),
                      ),
                    ],
                  ),
                ),
              ]),
            );
  }

  Container _homeCard(Size size) {
    return Container(
              width: size.width,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColor.gradientFirst.withOpacity(0.85),
                    AppColor.gradientSecond.withOpacity(0.9),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(85),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(5, 10),
                    blurRadius: 20,
                    color: AppColor.gradientSecond.withOpacity(0.2),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Next workout",
                      style: TextStyle(
                        color: AppColor.homePageContainerTextSmall,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Legs Toning",
                      style: TextStyle(
                        color: AppColor.homePageContainerTextSmall,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "and Glutes Workout",
                      style: TextStyle(
                        color: AppColor.homePageContainerTextSmall,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.timer_sharp,
                                size: 20,
                                color: AppColor.homePageContainerTextSmall),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "60 min",
                              style: TextStyle(
                                color: AppColor.homePageContainerTextSmall,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        InkWell(
                          onTap: () {
                            Get.to(() => const WorkoutScreen());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColor.gradientFirst,
                                      blurRadius: 10,
                                      offset: Offset(4, 8))
                                ]),
                            child: const Icon(
                              Icons.play_circle_fill,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
  }

  GridView _gridView() {
    return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      childAspectRatio: 1 / 1,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      maxCrossAxisExtent: 180,
                    ),
                    itemCount: info.length,
                    itemBuilder: (_, i) {
                      return Container(
                        height: 150,
                        width: 150,
                        padding: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: AssetImage(info[i]['img']),
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(5, 5),
                                blurRadius: 3,
                                color:
                                    AppColor.gradientSecond.withOpacity(0.1),
                              ),
                              BoxShadow(
                                offset: const Offset(-5, -5),
                                blurRadius: 3,
                                color:
                                    AppColor.gradientSecond.withOpacity(0.1),
                              ),
                            ]),
                        child: Center(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(info[i]['title'],
                                style: TextStyle(
                                    fontSize: 20,
                                    color: AppColor.homePageDetail)),
                          ),
                        ),
                      );
                    });
  }
}
