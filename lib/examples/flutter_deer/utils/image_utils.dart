import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ImageUtils {
  static ImageProvider getAssetImage(
    String name, {
    ImageFormat format = ImageFormat.png,
  }) {
    return AssetImage(getImagePath(name, format: format));
  }

  static String getImagePath(
    String name, {
    ImageFormat format = ImageFormat.png,
  }) {
    return 'assets/images/$name.${format.value}';
  }

  static ImageProvider getImageProvider(
    String? imageUrl, {
    String holderImg = 'none',
    ImageFormat format = ImageFormat.png,
  }) {
    if ((imageUrl ?? '').isEmpty) {
      return AssetImage(getImagePath(holderImg, format: format));
    }
    return ExtendedNetworkImageProvider(
      imageUrl!,
      cache: true,
    );
  }
}

enum ImageFormat {
  png,
  jpg,
  gif,
  webp,
}

extension ImageForamtExtension on ImageFormat {
  String get value => name;
}
