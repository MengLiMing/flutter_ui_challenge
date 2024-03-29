import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/image_utils.dart';

class LoadImage extends StatelessWidget {
  const LoadImage(
    this.image, {
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.format = ImageFormat.png,
    this.holderImg = 'none',
    this.cacheHeight,
    this.cacheWidth,
  }) : super(key: key);

  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ImageFormat format;
  final String holderImg;
  final int? cacheWidth;
  final int? cacheHeight;

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty || image.startsWith('http')) {
      final Widget holder = LoadAssetImage(
        holderImg,
        height: height,
        width: width,
        fit: fit,
      );
      return ExtendedImage.network(
        image,
        width: width,
        height: height,
        fit: fit,
        cache: true,
        enableMemoryCache: false,
        enableLoadState: false,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
            case LoadState.failed:
              return holder;
            case LoadState.completed:
              return AnimatedOpacity(
                opacity: 1,
                duration: const Duration(milliseconds: 100),
                child: ExtendedRawImage(image: state.extendedImageInfo?.image),
              );
          }
        },
      );
    } else {
      return LoadAssetImage(
        image,
        height: height,
        width: width,
        format: format,
        cacheHeight: cacheHeight,
        cacheWidth: cacheWidth,
        fit: fit,
      );
    }
  }
}

class LoadAssetImage extends StatelessWidget {
  const LoadAssetImage(this.image,
      {super.key,
      this.width,
      this.height,
      this.cacheWidth,
      this.cacheHeight,
      this.fit,
      this.format = ImageFormat.png,
      this.color});

  final String image;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;
  final BoxFit? fit;
  final ImageFormat format;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImageUtils.getImagePath(image, format: format),
      height: height,
      width: width,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      fit: fit,
      color: color,

      /// 忽略图片语义
      excludeFromSemantics: true,
    );
  }
}
