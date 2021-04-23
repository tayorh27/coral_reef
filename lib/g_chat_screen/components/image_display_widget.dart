
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ImageDisplayWidget extends StatelessWidget {

  final String postImage;

  ImageDisplayWidget(this.postImage);

  final GlobalKey<ExtendedImageGestureState> gestureKey =
  GlobalKey<ExtendedImageGestureState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ExtendedImage.network(
      postImage,
      width: MediaQuery.of(context).size.width,//ScreenUtil.instance.setWidth(400),
      height: 400.0,//ScreenUtil.instance.setWidth(400),
      fit: BoxFit.cover,
      cache: true,
      shape: BoxShape.rectangle,
      mode: ExtendedImageMode.gesture,
      extendedImageGestureKey: gestureKey,
      initGestureConfigHandler: (ExtendedImageState state) {
        return GestureConfig(
          minScale: 0.9,
          animationMinScale: 0.7,
          maxScale: 4.0,
          animationMaxScale: 4.5,
          speed: 1.0,
          inertialSpeed: 100.0,
          initialScale: 1.0,
          inPageView: false,
          initialAlignment: InitialAlignment.center,
          gestureDetailsIsChanged: (GestureDetails details) {
            //print(details?.totalScale);
          },
        );
      },
      //cancelToken: cancellationToken,
    );
  }
}