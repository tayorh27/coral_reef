import 'package:coral_reef/g_chat_screen/components/shimmer_effects.dart';
import 'package:flutter/material.dart';

class BlogPostScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BlogPostScreen();
}

class _BlogPostScreen extends State<BlogPostScreen> {
  bool hasLoadedContent = false;
  var imageNetwork = NetworkImage(
      "https://firebasestorage.googleapis.com/v0/b/taconlinegiftshop.appspot.com/o/logo-3.png?alt=media&token=92f27f22-efdb-4455-9628-8e9ac7ae99c6");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageNetwork.resolve(new ImageConfiguration()).addListener(
        new ImageStreamListener((ImageInfo image, bool synchronousCall) {
          if (!mounted) return;
          print(synchronousCall);
          setState(() {
            hasLoadedContent = true;
          });
        }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ShimmerEffects(LoadingBlogPost(), 2.0);
  }
}
