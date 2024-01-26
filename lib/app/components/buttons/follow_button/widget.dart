import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../data/models/user.dart';
import 'controller.dart';

class FollowButton extends StatefulWidget {
  final UserModel user;

  const FollowButton({
    super.key,
    required this.user,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton>
    with AutomaticKeepAliveClientMixin {
  late FollowButtonController _controller;

  @override
  void initState() {
    super.initState();
    Get.create(() => FollowButtonController());
    _controller = Get.find();
    _controller.init(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      if (_controller.isFollowing) {
        return FilledButton(
          style: FilledButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.outline,
            backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
          ),
          onPressed: _controller.isProcessing ? null : _controller.unfollow,
          child: AutoSizeText(
            t.profile.following,
            maxLines: 1,
          ),
        );
      } else {
        return FilledButton(
          onPressed: _controller.isProcessing ? null : _controller.follow,
          child: AutoSizeText(
            t.profile.follow,
            maxLines: 1,
          ),
        );
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
