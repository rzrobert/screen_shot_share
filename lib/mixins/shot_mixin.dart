import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';

@optionalTypeArgs
mixin ShotMixin<T extends StatefulWidget> on State<T> {
  AnimationController get widthFactorAnimationController;

  late Animation<double> _widthFactorAnimation;
  late Animation<double> _paddingAnimation;

  double actionH = 80;
  Widget? actions;

  @override
  void initState() {
    super.initState();
    _widthFactorAnimation = Tween<double>(begin: 1, end: .7)
        .animate(widthFactorAnimationController);
    _paddingAnimation =
        Tween<double>(begin: 0, end: 1).animate(widthFactorAnimationController);
  }

  Future<File?> shot() async {
    File? file;
    if (await Permission.photos.request().isGranted) {
      file = await _shareUiImage();
      if (file != null) {
        showDeleteConfirmDialog(file);
        return file;
      }
    } else {
      debugPrint('===shot==error===');
    }
    return null;
  }

  /// 截屏图片生成图片流ByteData
  Future<ByteData?> _capturePngToByteData() async {
    try {
      RenderRepaintBoundary? boundary = screenShotKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      double dpr = ui.window.devicePixelRatio; // 获取当前设备的像素比
      if (boundary != null) {
        if (boundary.debugNeedsPaint) {
          await Future.delayed(const Duration(milliseconds: 20));
        }
        ui.Image image = await boundary.toImage(pixelRatio: dpr);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        return byteData;
      }
    } catch (e) {
      debugPrint('===shot===capturePngToByteData====e: $e');
    }
    return null;
  }

  /// 把图片ByteData写入File
  Future<File?> _shareUiImage() async {
    ByteData? sourceByteData = await _capturePngToByteData();
    if (sourceByteData != null) {
      Uint8List sourceBytes = sourceByteData.buffer.asUint8List();
      Directory tempDir = await getTemporaryDirectory();

      String storagePath = tempDir.path;
      File file = File('$storagePath/shot.png');

      if (file.existsSync()) {
        file.deleteSync();
      }
      file.createSync();
      file.writeAsBytesSync(sourceBytes);
      return file;
    }

    return null;
  }

  Future<bool?> showDeleteConfirmDialog(File file) async {
    widthFactorAnimationController.reset();
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    Size size = mediaQueryData.size;
    double left = size.height * .3 - mediaQueryData.padding.bottom;
    double actionHeight = min(left, actionH);
    double actionPaddingBottom = (left - actionHeight) / 2;
    FileImage img = FileImage(file);

    bool? res = await showDialog<bool>(
      context: context,
      useSafeArea: false,
      builder: (context) {
        widthFactorAnimationController.forward();
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _widthFactorAnimation,
                builder: (BuildContext c, Widget? child) {
                  double value = _widthFactorAnimation.value;
                  return Container(
                    padding: EdgeInsets.only(
                        bottom: actionHeight * _paddingAnimation.value),
                    child: FractionallySizedBox(
                      widthFactor: value,
                      child: Image(image: img),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: mediaQueryData.padding.bottom + actionPaddingBottom,
                child: FadeTransition(
                  opacity: _paddingAnimation,
                  child: Container(
                    height: actionHeight,
                    width: size.width,
                    alignment: Alignment.center,
                    child: actions,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    PaintingBinding.instance.imageCache.evict(img);
    return null;
  }
}
