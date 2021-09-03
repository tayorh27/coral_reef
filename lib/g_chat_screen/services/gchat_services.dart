import 'dart:convert';
import 'dart:io';
import 'dart:math' as Math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_gchat.dart';
import 'package:coral_reef/ListItem/model_gchat_comment.dart';
import 'package:coral_reef/ListItem/model_gchat_like.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants.dart';

class GChatServices {
  StorageSystem ss = new StorageSystem();
  BuildContext context;

  GChatServices(BuildContext _context) {
    this.context = _context;
  }

  Future<void> saveDraft(
      {String title,
      String body,
      File file,
      String fileType,
      File thumbnail, List<dynamic> topics}) async {
    Map<String, dynamic> draft = new Map();
    draft["title"] = title;
    draft["body"] = body;
    draft["topics"] = (topics == null) ? "" : topics.join(",");
    draft["fileType"] = fileType;
    draft["file"] = (file == null) ? "" : file.path;
    draft["thumbnail"] = (thumbnail == null) ? "" : thumbnail.path;

    await ss.setPrefItem("gchat_draft", jsonEncode(draft));
    new GeneralUtils().showToast(context, "Draft saved.");
  }

  Future<dynamic> restoreDraft() async {
    String draft = await ss.getItem("gchat_draft") ?? "";
    if (draft.isEmpty) {
      return null;
    }
    Map<String, dynamic> result = jsonDecode(draft);
    return result;
  }

  Future<String> uploadFileToStorage(File _file) async {
    String key = FirebaseDatabase.instance.reference().push().key;
    String fileExt = _file.path.substring(_file.path.lastIndexOf(".") + 1);
    // print(fileExt);
    final Reference ref = FirebaseStorage.instance
        .ref()
        .child('gchat-files')
        .child('$key.$fileExt');
    final UploadTask uploadTask = ref.putFile(_file);
    await uploadTask.whenComplete(() {});
    TaskSnapshot storageTaskSnapshot = uploadTask.snapshot;
    return await storageTaskSnapshot.ref.getDownloadURL();
  }

  Future<String> createDynamicLink(
      String id, String title, String desc, String thumbnailUrl) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://coralreef.page.link',
      link: Uri.parse('https://coralreef.com/gchat?id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'com.rae.coral_reef',
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.rae.coral_reef',
        minimumVersion: '1.0.0',
        appStoreId: '123456789',
      ),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'share-gchat-link',
        medium: 'social',
        source: 'app',
      ),
      // itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
      //   providerToken: '123456',
      //   campaignToken: 'example-promo',
      // ),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: title, description: desc, imageUrl: Uri.parse(thumbnailUrl)),
    );

    final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;
    return shortUrl.toString();
  }

  Future<File> compressAndGetFile(File file) async {
    String key = FirebaseDatabase.instance.reference().push().key;
    File tempFile =
        new File('${(await getTemporaryDirectory()).path}/$key.jpeg');
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      tempFile.path,
      quality: 70,
    );
    return result;
  }

  Future<void> saveLikeData(String key, GChat gchat, String type, String commentID) async {
    //get user data
    String user = await ss.getItem('user');
    Map<String, dynamic> json = jsonDecode(user);

    //get avatar settings
    String avatar = await ss.getItem("avatar");
    dynamic avatarData = jsonDecode(avatar);

    //get username and topics
    String topics = await ss.getItem("topics");
    Map<String, dynamic> topicsData = jsonDecode(topics);
    String username = topicsData["username"];

    String gchatID = (gchat == null) ? "" : gchat.id;
    GChatLike gChatLike = new GChatLike(key, gchatID, commentID, type, json["uid"], username, avatarData,
        new DateTime.now().toString(), FieldValue.serverTimestamp());

    await FirebaseFirestore.instance
        .collection("likes")
        .doc(key)
        .set(gChatLike.toJSON());
  }

  Future<void> removeLikeData(String id) async {
    await FirebaseFirestore.instance.collection("likes").doc(id).delete();
  }

  shortenLargeNumber({double num = 0, int digits = 2}) {
    const units = ['K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y'];
    double decimal = 0.0;

    for (int i = units.length - 1; i >= 0; i--) {
      decimal = Math.pow(1000, i + 1).toDouble();

      if (num <= -decimal || num >= decimal) {
        return "${(num / decimal).toStringAsFixed(digits)}${units[i]}";
      }
    }

    return "${num.ceil()}";
  }

  Future<GChatComment> submitPostComment(String comment, String gchat_id, String main_comment_id, String replyUserID) async {

    String key = FirebaseDatabase.instance.reference().push().key;

    //get user data
    String user = await ss.getItem('user');
    Map<String, dynamic> json = jsonDecode(user);

    //get avatar settings
    String avatar = await ss.getItem("avatar");
    dynamic avatarData = jsonDecode(avatar);

    //get username and topics
    String topics = await ss.getItem("topics");
    Map<String, dynamic> topicsData = jsonDecode(topics);
    String username = topicsData["username"];

    String timeZone = await new GeneralUtils().currentTimeZone();
    String locale = Platform.localeName.split("_")[0].toLowerCase();
    // if(main_comment_id.isEmpty) {
    //   main_comment_id = key; //in case of new comments
    // }
    GChatComment gChatComment = new GChatComment(key, main_comment_id, gchat_id, json["uid"], replyUserID, username, avatarData, comment, new DateTime.now().toString(), json["msgId"], FieldValue.serverTimestamp(), timeZone, 0, locale);

    await FirebaseFirestore.instance.collection("comments").doc(key).set(gChatComment.toJSON());

    return gChatComment;
  }

  Future<void> updateCommentNumberOfLikesByID(String commentID, int increment) async {
    await FirebaseFirestore.instance.collection("comments").doc(commentID).update(
        {
          "number_of_likes" : FieldValue.increment(increment)
        });
  }

  Future<void> removeRecentCommentFromGChat(dynamic comment, String gchatID) async {
    await FirebaseFirestore.instance.collection("gchats").doc(gchatID).update(
        {
          "recent_comments" : FieldValue.arrayRemove([comment]),
          "number_of_comments": FieldValue.increment(-1)
        });
  }

  Future<void> removeCommentFromGChat(dynamic comment, String commentID, String gchatID) async {
    await FirebaseFirestore.instance.collection("comments").doc(commentID).delete();
    await FirebaseFirestore.instance.collection("gchats").doc(gchatID).update(
        {
          "recent_comments" : FieldValue.arrayRemove([comment]),
          "number_of_comments": FieldValue.increment(-1)
        });
  }

  Future<void> deleteGChat(String gchatID) async {
    await FirebaseFirestore.instance.collection("gchats").doc(gchatID).update({
      "visibility": "banned"
    }); //should it be deleted or banned?
  }



}
