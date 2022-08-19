// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/image_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/toast.dart';

mixin GoodsEditProviders {
  final manager =
      StateNotifierProvider.autoDispose<GoodsEditStateNotifier, GoodsEditState>(
          (ref) => GoodsEditStateNotifier(ref: ref));

  late final isLoading =
      Provider.autoDispose<bool>((ref) => ref.watch(manager).isLoading);

  /// 商品图片
  late final goodsImage = Provider.autoDispose<ImageProvider>((ref) {
    final result = ref.watch(manager);
    if (result.image.url == null && result.image.imageFile != null) {
      return FileImage(result.image.imageFile!);
    } else {
      return ImageUtils.getImageProvider(
          result.image.url ?? result.data.imageUrl,
          holderImg: 'store/icon_zj');
    }
  });

  /// 商品信息
  late final goodsData =
      Provider.autoDispose<GoodsData>((ref) => ref.watch(manager).data);

  /// 商品类型改动
  late final goodsTypeChange =
      Provider.autoDispose<String?>((ref) => ref.watch(goodsData).goodsType);

  /// 商品规格改动
  late final goodsSpecChange =
      Provider.autoDispose<String?>((ref) => ref.watch(goodsData).goodsSpec);

  /// 是否可以提交
  late final canCommit =
      Provider.autoDispose<bool>((ref) => ref.watch(manager).canCommit);
}

class GoodsEditStateNotifier extends StateNotifier<GoodsEditState> {
  Ref ref;
  GoodsEditStateNotifier({required this.ref}) : super(GoodsEditState()) {
    ref.onDispose(() {
      /// 可以停止网络请求
      // print('onDispose');
    });
  }

  /// 选择图片
  void setImage(File image) {
    state = state.copyWith(image: state.image.copyWith(image: image));
  }

  Future<void> commit() async {
    state = state.copyWith(isLoading: true);
    await uploadImage();
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isLoading: false);
    return;
  }

  /// 上传图片
  Future<void> uploadImage() async {
    if (state.image.url != null) return;
    if (state.image.imageFile == null) {
      Toast.show('请选择图片');
      return;
    }
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      isLoading: false,
      image: state.image.copyWith(
        url:
            'https://avatars.githubusercontent.com/u/19296728?s=400&u=7a099a186684090f50459c87176cf4d291a27ac7&v=4',
        image: state.image.imageFile,
      ),
    );
    return;
  }

  /// 修改商品信息
  void changeGoodsData({
    String? imageUrl,
    String? name,
    String? desc,
    double? price,
    String? code,
    String? remark,
    double? reducePrice,
    double? discountPrice,
    String? goodsType,
    String? goodsSpec,
  }) {
    state = state.copyWith(
      data: state.data.copyWith(
        imageUrl: imageUrl,
        name: name,
        desc: desc,
        price: price,
        code: code,
        remark: remark,
        reducePrice: reducePrice,
        discountPrice: discountPrice,
        goodsType: goodsType,
        goodsSpec: goodsSpec,
      ),
    );
  }
}

class GoodsEditState {
  /// 是否正在加载中
  final bool isLoading;

  /// 选择的图片
  final UploadImage image;

  /// 商品信息
  final GoodsData data;

  bool get canCommit =>
      image.imageFile != null &&
      data.name.isNotEmpty &&
      data.desc.isNotEmpty &&
      data.price != 0 &&
      data.reducePrice != 0 &&
      data.discountPrice != 0 &&
      data.goodsType != null &&
      data.goodsSpec != null;

  GoodsEditState({
    this.isLoading = false,
    this.image = const UploadImage(),
    this.data = const GoodsData(),
  });

  GoodsEditState copyWith({
    bool? isLoading,
    UploadImage? image,
    GoodsData? data,
  }) {
    return GoodsEditState(
      isLoading: isLoading ?? this.isLoading,
      image: image ?? this.image,
      data: data ?? this.data,
    );
  }

  @override
  bool operator ==(covariant GoodsEditState other) {
    if (identical(this, other)) return true;

    return other.isLoading == isLoading &&
        other.image == image &&
        other.data == data;
  }

  @override
  int get hashCode => isLoading.hashCode ^ image.hashCode ^ data.hashCode;
}

class GoodsData {
  final String? imageUrl;

  final String name;

  final String desc;

  final double price;

  final String code;

  final String remark;

  /// 立减金额
  final double reducePrice;

  /// 折扣金额
  final double discountPrice;

  /// 商品类型
  final String? goodsType;

  /// 商品规格
  final String? goodsSpec;

  const GoodsData({
    this.imageUrl,
    this.name = '',
    this.desc = '',
    this.price = 0,
    this.code = '',
    this.remark = '',
    this.reducePrice = 0,
    this.discountPrice = 0,
    this.goodsType,
    this.goodsSpec,
  });

  @override
  bool operator ==(covariant GoodsData other) {
    if (identical(this, other)) return true;

    return other.imageUrl == imageUrl &&
        other.name == name &&
        other.desc == desc &&
        other.price == price &&
        other.code == code &&
        other.remark == remark &&
        other.reducePrice == reducePrice &&
        other.discountPrice == discountPrice &&
        other.goodsType == goodsType &&
        other.goodsSpec == goodsSpec;
  }

  @override
  int get hashCode {
    return imageUrl.hashCode ^
        name.hashCode ^
        desc.hashCode ^
        price.hashCode ^
        code.hashCode ^
        remark.hashCode ^
        reducePrice.hashCode ^
        discountPrice.hashCode ^
        goodsType.hashCode ^
        goodsSpec.hashCode;
  }

  GoodsData copyWith({
    String? imageUrl,
    String? name,
    String? desc,
    double? price,
    String? code,
    String? remark,
    double? reducePrice,
    double? discountPrice,
    String? goodsType,
    String? goodsSpec,
  }) {
    return GoodsData(
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      price: price ?? this.price,
      code: code ?? this.code,
      remark: remark ?? this.remark,
      reducePrice: reducePrice ?? this.reducePrice,
      discountPrice: discountPrice ?? this.discountPrice,
      goodsType: goodsType ?? this.goodsType,
      goodsSpec: goodsSpec ?? this.goodsSpec,
    );
  }
}

class UploadImage {
  final File? imageFile;
  final String? url;

  const UploadImage({this.imageFile, this.url});

  @override
  bool operator ==(covariant UploadImage other) {
    if (identical(this, other)) return true;

    return other.imageFile?.path == imageFile?.path && other.url == url;
  }

  @override
  int get hashCode => (imageFile?.path ?? '').hashCode ^ url.hashCode;

  UploadImage copyWith({
    File? image,
    String? url,
  }) {
    if (image == null) {
      return const UploadImage();
    } else {
      return UploadImage(
        imageFile: image,
        url: url ?? this.url,
      );
    }
  }
}
