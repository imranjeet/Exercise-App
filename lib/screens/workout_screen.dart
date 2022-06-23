import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../misc/colors.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  bool _isPlayArea = false;
  List videoinfo = [];
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _disposed = false;
  int _isPlayingIndex = -1;

  _initData() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/videoinfo.json")
        .then((value) {
      setState(() {
        videoinfo = json.decode(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _disposed = true;
    _controller?.pause();
    _controller?.dispose();
    // _controller? = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: _isPlayArea == false
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColor.gradientFirst.withOpacity(0.9),
                    AppColor.gradientSecond,
                  ],
                  begin: const FractionalOffset(0.0, 0.4),
                  end: Alignment.topRight,
                ),
              )
            : const BoxDecoration(
                color: Color(0xFF6985e8),
              ),
        child: Column(
          children: [
            _isPlayArea == false
                ? _headerArea(size)
                : Container(
                    child: Column(children: [
                      Container(
                        height: 100,
                        padding:
                            const EdgeInsets.only(top: 50, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.arrow_back_ios,
                                  color: AppColor.secondPageIconColor,
                                  size: 20),
                            ),
                            Icon(Icons.info_outline,
                                color: AppColor.secondPageIconColor, size: 20),
                          ],
                        ),
                      ),
                      _videoView(context, size),
                      _controllerView(context),
                    ]),
                  ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(70),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        Text(
                          "Circuit 1: Legs Toning",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColor.circuitsColor),
                        ),
                        Expanded(child: Container()),
                        Row(
                          children: [
                            Icon(Icons.loop,
                                size: 25, color: AppColor.loopColor),
                            const SizedBox(width: 10),
                            Text(
                              "3 sets",
                              style: TextStyle(
                                  fontSize: 15, color: AppColor.setsColor),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(child: _listView())
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  convertTow(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  Duration? _duration;
  Duration? _position;
  var _progress = 0.0;

  Widget _controllerView(BuildContext context) {
    final noMute = (_controller?.value.volume ?? 0) > 0;
    final duration = _duration?.inSeconds ?? 0;
    final head = _position?.inSeconds ?? 0;
    final remained = max(0, duration - head);
    final mins = convertTow(remained ~/ 60.0);
    final secs = convertTow(remained % 60);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(
            bottom: 5,
          ),
          color: AppColor.gradientSecond,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  if (noMute) {
                    _controller?.setVolume(0);
                  } else {
                    _controller?.setVolume(1);
                  }
                  setState(() {});
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0.0, 0.0),
                          blurRadius: 4.0,
                          color: Color.fromARGB(50, 0, 0, 0),
                        ),
                      ],
                    ),
                    child: Icon(
                        noMute == true ? Icons.volume_up : Icons.volume_off,
                        color: Colors.white),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    final index = _isPlayingIndex - 1;
                    if (index >= 0 && videoinfo.length >= 0) {
                      _initializeVideo(index);
                    } else {
                      Get.snackbar(
                        "Video",
                        "",
                        icon: const Icon(Icons.face,
                            size: 30, color: Colors.white),
                        backgroundColor: AppColor.gradientSecond,
                        snackPosition: SnackPosition.BOTTOM,
                        colorText: Colors.white,
                        messageText: const Text(
                            "You have finished watching all of the videos. Congrates !",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      );
                    }
                  },
                  icon: const Icon(Icons.fast_rewind,
                      size: 20, color: Colors.white)),
              IconButton(
                  onPressed: () async {
                    if (_isPlaying) {
                      _controller?.pause();
                      setState(() {
                        _isPlaying = false;
                      });
                    } else {
                      _controller?.play();
                      setState(() {
                        _isPlaying = true;
                      });
                    }
                  },
                  icon: Icon(
                      _isPlaying == true ? Icons.pause : Icons.play_arrow,
                      size: 20,
                      color: Colors.white)),
              IconButton(
                onPressed: () async {
                  final index = _isPlayingIndex + 1;
                  if (index <= videoinfo.length - 1) {
                    _initializeVideo(index);
                  } else {
                    Get.snackbar(
                      "Video",
                      "",
                      icon:
                          const Icon(Icons.face, size: 30, color: Colors.white),
                      backgroundColor: AppColor.gradientSecond,
                      snackPosition: SnackPosition.BOTTOM,
                      colorText: Colors.white,
                      messageText: const Text(
                          "You have finished watching all of the videos. Congrates !",
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    );
                  }
                },
                icon: const Icon(Icons.fast_forward,
                    size: 20, color: Colors.white),
              ),
              Text("$mins:$secs",
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(0.0, 1.0),
                          blurRadius: 4.0,
                          color: Color.fromARGB(150, 0, 0, 0),
                        )
                      ])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _videoView(BuildContext context, Size size) {
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: VideoPlayer(controller),
      );
    } else {
      return const AspectRatio(
          aspectRatio: 16 / 9,
          child: Center(
              child: Text("Loading..",
                  style: TextStyle(fontSize: 20, color: Colors.white60))));
    }
  }

  var _onControllerUpdateTime;
  void _onControllerUpdate() async {
    if (_disposed) {
      return;
    }
    _onControllerUpdateTime = 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_onControllerUpdateTime > now) {
      return;
    }
    _onControllerUpdateTime = now + 500;
    final controller = _controller;
    if (controller == null) {
      debugPrint("controller is null");
      return;
    }
    if (!controller.value.isInitialized) {
      debugPrint("controller is not initialize.");
      return;
    }
    if (_duration == null) {
      _duration = _controller?.value.duration;
    }
    var duration = _duration;
    if (duration == null) return;

    var position = await controller.value.position;
    _position = position;

    final playing = controller.value.isPlaying;
    if (playing) {
      if (_disposed) return;
      setState(() {
        _progress = position.inMilliseconds.ceilToDouble() /
            duration.inMilliseconds.ceilToDouble();
      });
    }
    _isPlaying = playing;
  }

  _initializeVideo(int i) async {
    final controller = VideoPlayerController.network(videoinfo[i]['videoUrl']);
    final old = _controller;
    _controller = controller;
    if (old != null) {
      old.removeListener(_onControllerUpdate);
      old.pause();
    }
    setState(() {});
    controller
      ..initialize().then((_) {
        old?.dispose();
        _isPlayingIndex = i;
        controller.addListener(_onControllerUpdate);
        controller.play();
        setState(() {});
      });
  }

  Container _headerArea(Size size) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
      height: size.height * 0.36,
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back_ios,
                  color: AppColor.secondPageIconColor, size: 20),
            ),
            Icon(Icons.info_outline,
                color: AppColor.secondPageIconColor, size: 20),
          ]),
          const SizedBox(
            height: 30,
          ),
          Text(
            "Legs Toning",
            style: TextStyle(
              color: AppColor.secondPageTitleColor,
              fontSize: 25,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "and Glutes Workout",
            style: TextStyle(
              color: AppColor.secondPageTitleColor,
              fontSize: 25,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            children: [
              Container(
                  height: 30,
                  width: size.width * 0.23,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        AppColor.secondPageContainerGradient1stColor,
                        AppColor.secondPageContainerGradient2ndColor,
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer_sharp,
                          size: 18, color: AppColor.secondPageTitleColor),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "68 min",
                        style: TextStyle(
                          color: AppColor.secondPageTitleColor,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                width: 24,
              ),
              Container(
                height: 30,
                width: size.width * 0.59,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      AppColor.secondPageContainerGradient1stColor,
                      AppColor.secondPageContainerGradient2ndColor,
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.handyman_outlined,
                        size: 18, color: AppColor.secondPageTitleColor),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Resistent band, kettebell",
                      style: TextStyle(
                        color: AppColor.secondPageTitleColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ListView _listView() {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: videoinfo.length,
        itemBuilder: (_, i) {
          return GestureDetector(
            onTap: () {
              _initializeVideo(i);
              setState(() {
                if (_isPlayArea == false) {
                  _isPlayArea = true;
                }
              });

              debugPrint(i.toString());
            },
            child: _buildCard(i),
          );
        });
  }

  Container _buildCard(int i) {
    return Container(
      height: 130,
      width: 200,
      // color: Colors.redAccent,
      child: Column(children: [
        Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(videoinfo[i]['thumbnail']),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(videoinfo[i]['title'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(videoinfo[i]['time'],
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      )),
                )
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Container(
              width: 80,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFeaeefc),
              ),
              child: const Center(
                child: Text(
                  "15s rest",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF839fed),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                for (int j = 0; j < 70; j++)
                  j.isEven
                      ? Container(
                          width: 3,
                          height: 1,
                          decoration: BoxDecoration(
                            color: const Color(0xFF839fed),
                            borderRadius: BorderRadius.circular(2),
                          ))
                      : Container(
                          width: 3,
                          height: 1,
                          color: Colors.white,
                        ),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
