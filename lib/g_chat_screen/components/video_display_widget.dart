import 'package:chewie/chewie.dart';
import 'package:coral_reef/g_chat_screen/components/image_display_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDisplayWidget extends StatefulWidget {
  final String videoUrl;
  final String thumbImage;
  final bool showControls;
  final bool looping;
  final double aspectRatio;

  VideoDisplayWidget(this.videoUrl, this.thumbImage, {this.showControls = true, this.aspectRatio = 16/9, this.looping = false});

  @override
  State<StatefulWidget> createState() => _VideoDisplayWidget();
}

class _VideoDisplayWidget extends State<VideoDisplayWidget> {

  VideoPlayerController _videoPlayerController;

  bool isPlaying = false;

  ChewieController _chewieController;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //
  //   _controller = VideoPlayerController.network(widget.videoUrl)
  //     ..initialize().then((_) {
  //       // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
  //       // setState(() {});
  //       // _controller.setLooping(true);
  //       _controller.play();
  //       if(!mounted) return;
  //       setState(() {
  //         isPlaying = true;
  //       });
  //     });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(videoPlayerController: _videoPlayerController,
      aspectRatio: widget.aspectRatio,
      autoInitialize: true,
      autoPlay: true,
      looping: widget.looping,
      allowMuting: true,
      showControls: widget.showControls,
      showControlsOnInitialize: false,
      allowedScreenSleep: true,
      errorBuilder: (context, errorMessage) {
        return ImageDisplayWidget(widget.thumbImage);
      }
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 400.0,
      child: Chewie(controller: _chewieController),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   // TODO: implement build
  //   return GestureDetector(
  //     child: _controller.value.isInitialized
  //         ? AspectRatio(
  //       aspectRatio: _controller.value.aspectRatio,
  //       child: VideoPlayer(_controller),
  //     )
  //         : ImageDisplayWidget(widget.thumbImage),
  //     onTap: () async {
  //       Duration getDur = await _controller.position;
  //       print("dur = ${getDur.inSeconds}");
  //       if(isPlaying) {
  //         _controller.pause();
  //       }else {
  //         _controller.play();
  //       }
  //
  //       setState(() {
  //         isPlaying = !isPlaying;
  //       });
  //     },
  //   );
  // }
}
