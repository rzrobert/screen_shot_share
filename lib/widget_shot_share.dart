library widget_shot_share;

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:widget_shot_share/constants.dart';
import 'package:widget_shot_share/shot_controller_base.dart';

import 'mixins/shot_mixin.dart';

class WidgetShotShare extends StatefulWidget {
  const WidgetShotShare({
    Key? key,
    required this.child,
    required this.shotController,
    this.actionHeight = 80,
    this.actions,
  }) : super(key: key);

  final Widget child;
  final ShotController shotController;
  final double actionHeight;
  final Widget? actions;

  @override
  // ignore: library_private_types_in_public_api
  _WidgetShotShareState createState() => _WidgetShotShareState();
}

class _WidgetShotShareState extends State<WidgetShotShare>
    with ShotMixin, SingleTickerProviderStateMixin {
  late AnimationController _widthFactorAnimationController;

  @override
  AnimationController get widthFactorAnimationController =>
      _widthFactorAnimationController;
  @override
  void initState() {
    actionH = widget.actionHeight;
    actions = widget.actions;
    _widthFactorAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    widget.shotController._bind(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: screenShotKey,
      child: widget.child,
    );
  }
}

class ShotController extends ShotControllerBase {
  _WidgetShotShareState? _state;

  _bind(_WidgetShotShareState state) {
    _state = state;
  }

  @override
  Future<File?> shot() async {
    return _state?.shot();
  }
}
