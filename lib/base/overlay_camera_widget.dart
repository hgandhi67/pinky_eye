import 'dart:async';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinky_eye/base/ads/app_ads.dart';
import 'package:pinky_eye/base/routes.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';
import 'package:toast/toast.dart';

class CameraOverlayWidget extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraOverlayWidget({Key key, this.cameras}) : super(key: key);

  @override
  _CameraOverlayWidgetState createState() => _CameraOverlayWidgetState();
}

class _CameraOverlayWidgetState extends State<CameraOverlayWidget> {
  File clickedImage;
  CameraController controller;
  bool frontCamera = true;
  double scale = 1.0;

  @override
  void initState() {
    super.initState();
    AppAds.dispose();
    availableCameras().then((camera) {
      controller = CameraController(widget.cameras[1], ResolutionPreset.high);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        } else {
          setState(() {
            //refresh
          });
        }
      }).catchError((onError) {
        print('catchError-->> $onError');
        if (onError is CameraException) {
          openSettingsPopup();
        }
      });
    });
  }

  /// open popup which asks user to open settings
  void openSettingsPopup() {
    print('openSettingsPopup-->> ');
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              content: Text(
                'Please give camera permissions from settings to use application functionalities',
                textAlign: TextAlign.center,
                style: Styles.workSans500New(color: Colors.black, fontSize: 18),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    print('Permission has been denied okkkkkkkkkk');

                    AppSettings.openAppSettings();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Navigator.of(context).popAndPushNamed(
        AppRoutes.REPORT_ANALYZING,
        arguments: {
          AppRouteArgKeys.REPORT_ANALYZING_IMAGE: image,
          AppRouteArgKeys.IS_FROM_DEPENDENT: 'Me',
        },
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    AppAds.init();
    AppAds.showBanner(
      anchorType: AnchorType.bottom,
      childDirected: true,
      listener: AppAds.bannerListener,
      size: AdSize.banner,
    );
    super.dispose();
  }

  void _takePicture() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/';
    await Directory(dirPath).create(recursive: true);
    final String filePath =
        '$dirPath/${DateTime.now().millisecondsSinceEpoch.toString()}.png';
    await controller.takePicture(filePath);
    clickedImage = File(filePath);
    if (clickedImage != null) {
      Navigator.of(context).popAndPushNamed(
        AppRoutes.REPORT_ANALYZING,
        arguments: {
          AppRouteArgKeys.REPORT_ANALYZING_IMAGE: clickedImage,
          AppRouteArgKeys.IS_FROM_DEPENDENT: 'Me',
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Scaffold(
        body: const SizedBox(),
      );
    }
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            CameraPreview(controller),
            _clickLayout(),
            _backLayout(),
          ],
        ),
      ),
    );
  }

  Widget _backLayout() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              padding: const EdgeInsets.all(0),
              icon: Icon(
                Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
                size: 25,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _clickLayout() {
    return Column(
      children: <Widget>[
        _getClickImageBox(),
        _shutterLayout(),
      ],
    );
  }

  Widget _getClickImageBox() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Hold the screen to take the photo.\nMaintain 15cm/6in distance.\nFocus on the eye.',
            textAlign: TextAlign.center,
            style: Styles.smallTextStyle,
          ),
          const SizedBox(
            height: 15.0,
          ),
          Container(
            height: MediaQuery.of(context).size.width * 0.7,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.transparent,
                border: Border.all(color: Colors.red, width: 2.0)),
            child: SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _shutterLayout() {
    return Container(
      color: Color(0xFF303030),
      height: MediaQuery.of(context).size.height * 0.15,
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(15.0),
            width: 60.0,
            height: 60.0,
            child: GestureDetector(
              onTap: () {
                getImage();
              },
              child: Image.asset('images/gallery_ic.png'),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: GestureDetector(
                  onTap: () => _takePicture(),
                  child: Image.asset(
                    'images/capture_ic.png',
                    height: 80,
                    width: 80,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15.0),
            width: 60.0,
            height: 60.0,
            child: GestureDetector(
              onTap: _switchCamera,
              child: Icon(
                frontCamera ? Icons.camera_rear : Icons.camera_front,
                color: Palette.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _switchCamera() async {
    final CameraDescription cameraDescription =
        (controller.description == widget.cameras[0])
            ? widget.cameras[1]
            : widget.cameras[0];
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.medium);
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        Toast.show(
            'Camera error ${controller.value.errorDescription}', context);
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      Toast.show('Camera error ${controller.value.errorDescription}', context);
    }

    if (mounted) {
      setState(() {
        frontCamera = !frontCamera;
      });
    }
  }
}
