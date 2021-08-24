import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CarouselSlider31 extends StatefulWidget {
  String videoUrl;
  CarouselSlider31(this.videoUrl);
  @override
  _CarouselSlider createState() => _CarouselSlider();
}

class _CarouselSlider extends State<CarouselSlider31> {
  VideoPlayerController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _controller.play();
        _controller.setLooping(false);
        setState(() {});
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    print("dispose" + widget.videoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8.0),
          // image: DecorationImage(
          //   image: NetworkImage(
          //       albums[index]['img'][i]['imgurl']),
          //   fit: BoxFit.cover,
          // ),
        ),
        child: VideoPlayer(_controller));
  }
}
