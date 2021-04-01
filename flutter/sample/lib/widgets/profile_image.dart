import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/sun.dart';

class ProfileImage extends StatefulWidget {
  ProfileImage(this.big) : assert(big != null);

  final bool big;
  static Uint8List _image;

  static void emptyCache() {
    ProfileImage._image = null;
  }

  @override
  State<StatefulWidget> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  Future<Uint8List> _getImage() async {
    ProfileImage._image ??= await nh.profile.getUserImage();

    return ProfileImage._image;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _getImage(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ClipOval(
            child: Image.memory(
              snapshot.data,
              width: widget.big ? 96 : 48,
              height: widget.big ? 96 : 48,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  SunIcons.user_profile,
                  color: colors.primaryColor.shade400,
                  size: widget.big ? 96 : 48,
                );
              },
            ),
          );
        }

        return Icon(
          SunIcons.user_profile,
          color: colors.primaryColor.shade400,
          size: widget.big ? 96 : 48,
        );
      },
    );
  }
}
