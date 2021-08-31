import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coral_reef/ListItem/model_gchat.dart';
import 'package:coral_reef/Utils/colors.dart';
import 'package:coral_reef/Utils/general.dart';
import 'package:coral_reef/Utils/storage.dart';
import 'package:coral_reef/components/coral_back_button.dart';
import 'package:coral_reef/g_chat_screen/components/topics_selection.dart';
import 'package:coral_reef/g_chat_screen/services/gchat_services.dart';
import 'package:coral_reef/shared_screens/gchat_user_avatar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:video_compress/video_compress.dart';

import '../../size_config.dart';

class CreateNewGChat extends StatefulWidget {
  static final routeName = "create-new-gchat";
  final GChat mChat;
  CreateNewGChat({this.mChat});

  @override
  State<StatefulWidget> createState() => _CreateNewGChat();
}

class _CreateNewGChat extends State<CreateNewGChat> {

  bool isVisible = false, published = false;

  GChat editGChat;

  GChatServices gServices;

  bool _inAsyncCall = false;

  TextEditingController _controllerTitle = new TextEditingController(text: "");
  TextEditingController _controllerBody = new TextEditingController(text: "");

  File postFile;

  String fileType = "image";
  File thumbnail;

  Subscription _subscription;
  double videoCompressProgress = 0.0;
  bool showProgress = false;

  bool disablePublishBtn = false;

  StorageSystem ss = new StorageSystem();

  String gifURL = "";

  List<String> topics = [
    "Sex life",
    "Relationships",
    "My body",
    "Health",
    "Period and cycle",
    "Parenting",
    "Pregnancy",
    "Entertainment",
    "Harmony",
    "Trying to conceive"
  ];

  List<dynamic> selectedTopics = [];
  bool isEdited = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gServices = GChatServices(context);

    _subscription =
        VideoCompress.compressProgress$.subscribe((progress) {
          if(!mounted) return;
          setState(() {
            videoCompressProgress = progress;
            disablePublishBtn = true;
          });
        });
  }

  void restoreDraft() {
    //restore draft if exists.
    gServices.restoreDraft().then((value) {
      if(value != null){
        setState(() {
          _controllerTitle.text = value["title"];
          _controllerBody.text = value["body"];
          selectedTopics = "${value["topics"]}".split(",");
          postFile = (value["file"] == "") ? null : new File(value["file"]);
          thumbnail = (value["thumbnail"] == "") ? null : new File(value["thumbnail"]);
          if(postFile != null) {
            isVisible = true;
            fileType = value["fileType"];
          }
        });
      }
    });
  }

  Future<void> loadGChatToEdit() async {
    if(editGChat == null) {
      restoreDraft();
      return;
    }

    if(editGChat != null) {
      setState(() {
        _inAsyncCall = true;
      });
      Map<String, dynamic> mediaInfo = editGChat.images[0];
      try {
        setState(() {
          _controllerTitle.text = editGChat.title;
          _controllerBody.text = editGChat.body;
          selectedTopics = editGChat.topics;
          isVisible = true;
          fileType = mediaInfo["fileType"];
          if(fileType == "gif") {
            gifURL = mediaInfo["url"];
            _inAsyncCall = false;
          }
        });

        if(fileType == "video"){
          //download image and save locally
          var imageId = await ImageDownloader.downloadImage(mediaInfo["thumbnailUrl"], destination: AndroidDestinationType.directoryDCIM);
          if (imageId != null) {
            var path = await ImageDownloader.findPath(imageId);
            setState(() {
              thumbnail = File(path);
              _inAsyncCall = false;
            });
          }
        }else {
          var imageId2 = await ImageDownloader.downloadImage(mediaInfo["url"], destination: AndroidDestinationType.directoryDCIM);
          if (imageId2 != null) {
            var path2 = await ImageDownloader.findPath(imageId2);
            setState(() {
              thumbnail = File(path2);
              postFile = File(path2);
              _inAsyncCall = false;
            });
          }
        }
      } on PlatformException catch (error) {
        print(error);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(editGChat == null) {
      if (!published) {
        if (_controllerTitle.text.isNotEmpty ||
            _controllerBody.text.isNotEmpty) {
          gServices.saveDraft(title: _controllerTitle.text,
              body: _controllerBody.text,
              file: postFile,
              fileType: fileType,
              thumbnail: thumbnail);
        }
      }
    }
    _subscription.unsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    editGChat = ModalRoute.of(context).settings.arguments as GChat;
    if(!isEdited) {
      isEdited = true;
      loadGChatToEdit();
    }
    return Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: _inAsyncCall,
          opacity: 0.6,
          progressIndicator: CircularProgressIndicator(),
          color: Color(MyColors.titleTextColor),
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(24)),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                          child: Column(
                        children: [
                          SizedBox(height: SizeConfig.screenHeight * 0.03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              CoralBackButton(
                                icon: Icon(
                                  Icons.clear,
                                  size: 32.0,
                                  color: Color(MyColors.titleTextColor),
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10.0),
                                    child: TextButton(
                                        onPressed: () {
                                          gServices.saveDraft(title: _controllerTitle.text, body: _controllerBody.text, file: postFile, fileType: fileType, thumbnail: thumbnail, topics: selectedTopics);
                                        },
                                        child: Text("Save Draft",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(color: Colors.grey))),
                                  ),
                                  Container(
                                    height: 35.0,
                                    margin: EdgeInsets.only(top: 10.0),
                                    decoration: BoxDecoration(
                                        color: Color(MyColors.other3),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: TextButton(
                                      onPressed: (disablePublishBtn) ? null : () {
                                        publicPost();
                                      },
                                      child: Text((editGChat == null) ? "Publish" : "Update",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  color: Color(
                                                      MyColors.primaryColor))),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            height: 1.0,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.02),
                          Row(
                            children: [
                              GChatUserAvatar(40.0),
                              SizedBox(
                                width: 20.0,
                              ),
                              Container(
                                height: 100.0,
                                width:
                                    MediaQuery.of(context).size.width - 130.0,
                                padding: EdgeInsets.only(top: 20.0),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _controllerTitle,
                                  maxLines: 1,
                                  maxLength: 40,
                                  maxLengthEnforcement: MaxLengthEnforcement
                                      .enforced,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Title",
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(color: Colors.grey),
                                      labelStyle: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: SizeConfig.screenHeight * 0.01),
                          Divider(
                            height: 1.0,
                            color: Colors.grey[300],
                          ),
                          Container(
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(top: 25.0, left: 0.0, bottom: 10.0),
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              controller: _controllerBody,
                              maxLines: 10,
                              minLines: 3,
                              maxLength: 600,
                              textCapitalization:
                              TextCapitalization.sentences,
                              maxLengthEnforcement: MaxLengthEnforcement
                                  .truncateAfterCompositionEnds,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Write post |",
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(color: Colors.grey),
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Row(
                            children: [
                              Text("Select the topic(s) for this post",
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(color: Color(MyColors.primaryColor), fontSize: 16.0),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: listTopics(),
                            ),
                          )
                        ],
                      )),
                      Positioned(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(color: Colors.grey[300]))),
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextButton(
                                    onPressed: onImageSelectionPressed,
                                    child: SvgPicture.asset(
                                        "assets/icons/gchat_image.svg"),
                                    style: ButtonStyle(
                                        alignment: Alignment.centerLeft),
                                  ),
                                  // TextButton(
                                  //     onPressed: onVideoSelectionPressed,
                                  //     child: SvgPicture.asset(
                                  //         "assets/icons/gchat_video.svg")),
                                  TextButton(
                                      onPressed: onGifImageSelectionPressed,
                                      child: SvgPicture.asset(
                                          "assets/icons/gchat_gif.svg")),
                                ],
                              )
                            ],
                          ),
                        ),
                        top: MediaQuery.of(context).size.height - 120,
                      ),
                      Visibility(
                          visible: showProgress,
                          child: Positioned(
                            child: Container(
                              child: Column(
                                children: [
                                  Text("Loading video...${videoCompressProgress.ceil()}% complete",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(color: Colors.grey)),
                                ],
                              )
                            ),
                            top: MediaQuery.of(context).size.height - 150,
                          )),
                      Visibility(
                          visible: isVisible,
                          child: Positioned(
                            child: Container(
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if(fileType == "image") {
                                        //re-crop image
                                        cropImageFileAndCompress(postFile);
                                      }
                                    },
                                    child: Container(
                                      width: 70.0,
                                      height: 50.0,
                                      margin: EdgeInsets.only(right: 20.0),
                                      decoration: BoxDecoration(
                                        // color: Colors.grey,
                                        image: DecorationImage(
                                            image: (fileType == "document") ? AssetImage(
                                                "assets/icons/icons8-file-96.png") : (fileType == "gif") ? NetworkImage(gifURL) : (thumbnail != null) ? FileImage(thumbnail) : AssetImage(
                                                "assets/icons/icons8-file-96.png")
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text("Ready to upload $fileType.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(color: Colors.grey)),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        setState(() {
                                          isVisible = false;
                                          postFile = null;
                                        });
                                      },
                                      child: Text("Remove",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                              .copyWith(
                                                  color: Colors.redAccent)))
                                ],
                              ),
                            ),
                            top: MediaQuery.of(context).size.height - 170,
                          ))
                    ],
                  )),
            ),
          ),
        ));
  }

  List<Widget> listTopics() {
    List<Widget> tops = [];
    topics.forEach((opt) {
      tops.add(TopicsSelection(
        text: opt,
        selected: (selectedTopics.contains(opt)) ? true : false,
        onTap: () {
          if (selectedTopics.contains(opt)) {
            setState(() {
              selectedTopics.remove(opt);
            });
          } else {
            setState(() {
              selectedTopics.add(opt);
            });
          }
          print(selectedTopics);
        },
      ));
    });
    return tops;
  }

  onImageSelectionPressed() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result != null) {
      print(result.paths);
      File file = File(result.files.first.path);
      cropImageFileAndCompress(file);
    }
  }

  Future<void> cropImageFileAndCompress(File file) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          // CropAspectRatioPreset.ratio3x2,
          // CropAspectRatioPreset.original,
          // CropAspectRatioPreset.ratio4x3,
          // CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Color(MyColors.primaryColor),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
    );

    //compress image

    postFile = await gServices.compressAndGetFile(croppedFile);
    setState(() {
      isVisible = true;
      fileType = "image";
      thumbnail = postFile;
    });
  }

  onVideoSelectionPressed() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.video, allowMultiple: false);
    if (result != null) {
      File file = File(result.files.first.path);

      setState(() {
        showProgress = true;
      });
      //compress video
      MediaInfo mediaInfo = await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: false, // It's false by default
      );

      print("media - ${mediaInfo.orientation}");

      postFile = mediaInfo.file;

      //get thumbnail
      File thumbnailFile = await VideoCompress.getFileThumbnail(
          file.path,
          quality: 70, // default(100)
          position: -1 // default(-1)
      );

      if(!mounted) return;

      setState(() {
        isVisible = true;
        showProgress = false;
        videoCompressProgress = 0.0;
        fileType = "video";
        thumbnail = thumbnailFile;
        disablePublishBtn = false;
      });
    }
  }

  onGifImageSelectionPressed() async {
    final gif = await GiphyPicker.pickGif(context: context, apiKey: "Ge8BxElqzT5BpIg3GORhD4CNhpEpfySu");

    if(gif != null) {
      print(gif.images.original.url);
      setState(() {
        gifURL = gif.images.original.url;
        // postFile = File("");
        fileType = "gif";
        isVisible = true;
      });
    }
  }

  onDocSelectionPressed() async { //method not used
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["pdf", "docx", "xlsx"],
        allowMultiple: false);
    if (result != null) {
      File file = File(result.files.first.path);
      postFile = file;
      setState(() {
        isVisible = true;
        fileType = "document";
      });
    }
  }

  Future<void> publicPost() async {
    if(selectedTopics.isEmpty) {
      new GeneralUtils().displayAlertDialog(context, "Attention",
          "Please select at least one topic for this post.");
      return;
    }
    if(fileType == "gif") {
      if (_controllerTitle.text.isEmpty || _controllerBody.text.isEmpty || gifURL == "") {
        new GeneralUtils().displayAlertDialog(context, "Attention",
            "Please fill all fields and attach a media asset to this post.");
        return;
      }
    }else {
      if (_controllerTitle.text.isEmpty || _controllerBody.text.isEmpty ||
          postFile == null) {
        new GeneralUtils().displayAlertDialog(context, "Attention",
            "Please fill all fields and attach a media asset to this post.");
        return;
      }
    }
    try {
      setState(() {
        _inAsyncCall = true;
      });

      String key = FirebaseDatabase.instance.reference().push().key;

      String fileUrl = "";
      if(fileType == "gif") {
        fileUrl = gifURL;
      } else {
        fileUrl = await gServices.uploadFileToStorage(postFile);
      }

      //get thumbnail url if file is video
      String thumbnailUrl = "";
      if(fileType == "video") {
        thumbnailUrl = await gServices.uploadFileToStorage(thumbnail);
      }

      Map<String, dynamic> mediaInfo = new Map();
      mediaInfo["fileType"] = fileType;
      mediaInfo["url"] = fileUrl;
      mediaInfo["thumbnailUrl"] = thumbnailUrl;

      //update gchat data
      if(editGChat != null) {
        await FirebaseFirestore.instance.collection("gchats").doc(editGChat.id).update(
            {
              "title":_controllerTitle.text,
              "body":_controllerBody.text,
              "images":[mediaInfo],
              "topics":selectedTopics,
              "edited": true,
              "modified": new DateTime.now().toString()
            });
        setState(() {
          _inAsyncCall = false;
          published = true;
        });
        new GeneralUtils().showToast(context, "Post updated.");
        Navigator.of(context).pop();
        return;
      }

      //get dynamic link
      String dynamicLink = await gServices.createDynamicLink(key, _controllerTitle.text, _controllerBody.text, fileUrl);

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
      // List<dynamic> _topics = topicsData["selectedTopics"];

      String timeZone = await new GeneralUtils().currentTimeZone();
      String locale = Platform.localeName.split("_")[0].toLowerCase();

      //populate gchat model
      GChat gChat = new GChat(key, json["uid"], username, avatarData, _controllerTitle.text, _controllerBody.text,
          [mediaInfo], 0, 0, 0, 0, [], new DateTime.now().toString(), FieldValue.serverTimestamp(), selectedTopics, false, dynamicLink, "published", timeZone, locale);


      await FirebaseFirestore.instance.collection("gchats").doc(key).set(gChat.toJSON());

      setState(() {
        _inAsyncCall = false;
        published = true;
      });

      new GeneralUtils().showToast(context, "Post published.");

      await ss.deletePref("gchat_draft");

      Timer(Duration(seconds: 2), (){
        Navigator.of(context).pop();
      });


    } catch (err) {
      setState(() {
        _inAsyncCall = false;
        new GeneralUtils().displayAlertDialog(context, "Error", "$err");
      });
    }
  }
}
