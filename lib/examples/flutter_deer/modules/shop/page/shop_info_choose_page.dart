import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/provider/shop_info_choose_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/widgets/shop_info_choose_indicator.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/custon_back_button.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/flutter_table_view/flutter_table_view.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';

enum ShopInfoChooseStyle {
  // 城市选择
  city,

  /// 银行名称
  bankName,

  /// 支行名称
  branchName,
}

class ShopInfoChoosePage extends ConsumerStatefulWidget {
  final ShopInfoChooseStyle style;

  const ShopInfoChoosePage({
    Key? key,
    required this.style,
  }) : super(key: key);

  @override
  ConsumerState<ShopInfoChoosePage> createState() => _ShopInfoChooseState();
}

class _ShopInfoChooseState extends ConsumerState<ShopInfoChoosePage>
    with ShopInfoChooseProviders {
  final FlutterTableViewController tableViewController =
      FlutterTableViewController();

  String get title => ['开户地点', '开户银行', '选择支行'][widget.style.index];

  @override
  void initState() {
    super.initState();

    ref.read(manager.notifier).cofigData(widget.style);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            const CustomBackButton(),
            Text(title),
          ],
        ),
      ),
      body: Stack(
        children: [
          tableView(),
          loading(),
          Positioned(
              top: 0, right: 0, width: 28, bottom: 0, child: _indicator()),
          _hintLetter(),
        ],
      ),
    );
  }

  Widget _hintLetter() {
    return Consumer(builder: (_, ref, __) {
      final letter = ref.watch(showLetter);
      return Opacity(
        opacity: letter == null ? 0 : 1,
        child: Center(
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Text(
              letter ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _indicator() {
    return Consumer(builder: (_, ref, __) {
      return ShopInfoChooseIndicator(
        datas: ref.watch(letters),
        onChanged: (index) {
          ref.read(manager.notifier).showLetterAtIndex(index);
          if (index != null) {
            tableViewController.jumpToSection(index);
          }
        },
      );
    });
  }

  Widget loading() {
    return Center(
      child: Consumer(builder: (context, ref, child) {
        final isLoading = ref.watch(this.isLoading);
        return Visibility(
          visible: isLoading,
          child: CupertinoActivityIndicator(
            animating: isLoading,
          ),
        );
      }),
    );
  }

  Widget tableView() {
    ref.listen(manager, (previous, next) {
      tableViewController.reloadData(isAll: true);
    });
    return FlutterTableView(
      padding: EdgeInsets.only(
        left: 16,
        right: 36,
        bottom: max(10, ScreenUtils.bottomPadding),
      ),
      sectionCount: () {
        return ref.read(manager).letters.length;
      },
      rowCount: (section) {
        return ref.read(manager.notifier).rowCount(section: section);
      },
      controller: tableViewController,
      headerBuilder: (context, sectionIndex) {
        final model = ref.read(manager.notifier).infoChooseModel(
              indexPath: IndexPath(row: 0, section: sectionIndex),
            );
        return model is ShopInfoCommonModel ? const _CommonHeader() : null;
      },
      footerBuilder: (context, sectionIndex) {
        final sectionCount = ref.read(manager).letters.length;
        return sectionIndex < (sectionCount - 1) ? const Divider() : null;
      },
      itemBuilder: (context, indexPath) {
        final model =
            ref.read(manager.notifier).infoChooseModel(indexPath: indexPath);
        if (model == null) return Container();
        if (model is ShopInfoCommonModel) {
          return _CommonBankItem(model: model);
        }
        return _ChooseInfoItem(model: model, isFirst: indexPath.row == 0);
      },
      onSelectedItem: (context, indexPath) {
        final model =
            ref.read(manager.notifier).infoChooseModel(indexPath: indexPath);
        if (model == null) return;
        NavigatorUtils.pop(context, result: model.origin);
      },
    );
  }
}

class _CommonHeader extends StatelessWidget {
  const _CommonHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 8),
      alignment: Alignment.centerLeft,
      child: const Text(
        '常用',
        style: TextStyle(
          fontSize: 12,
          color: Colours.textGray,
        ),
      ),
    );
  }
}

class _CommonBankItem extends StatelessWidget {
  final ShopInfoCommonModel model;
  const _CommonBankItem({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LoadAssetImage('account/${model.image}', width: 24.0),
          const SizedBox(width: 8),
          Text(model.name),
        ],
      ),
    );
  }
}

class _ChooseInfoItem extends StatelessWidget {
  final ShopInfoChooseModel model;
  final bool isFirst;
  const _ChooseInfoItem({
    Key? key,
    required this.model,
    required this.isFirst,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Row(
        children: [
          Opacity(
            opacity: isFirst ? 1 : 0,
            child: Text(model.firstLetter),
          ),
          const SizedBox(width: 16),
          Text(model.name),
        ],
      ),
    );
  }
}
