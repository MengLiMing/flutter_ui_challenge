// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/model/shop_record_model.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/provider/shop_record_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/flutter_table_view/flutter_table_view.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_more_footer.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';

class ShopRecordPage extends ConsumerStatefulWidget {
  const ShopRecordPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ShopRecordPage> createState() => _ShopRecordPageState();
}

class _ShopRecordPageState extends ConsumerState<ShopRecordPage>
    with ShopRecordProviders {
  List<ShopRecordSectionModel> get dataSource => ref.read(datas);

  final controller = FlutterTableViewController();

  @override
  void initState() {
    super.initState();

    ref.read(manager.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<void>(refresh, (_, __) {
      controller.refreshSuccess();
    });
    ref.listen<void>(loadMore, (_, __) {
      controller.loadMoreSuccess();
    });
    return Scaffold(
      appBar: const MyAppBar(
        title: Text('账户流水'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          RefreshIndicator(
            onRefresh: ref.read(manager.notifier).refresh,
            child: FlutterTableView(
              controller: controller,
              reverse: false,
              additionalNumber: 1,
              style: FlutterTableViewStyle.grouped,
              padding: EdgeInsets.only(bottom: ScreenUtils.bottomPadding),
              scrollDirection: Axis.vertical,
              sectionCount: () => dataSource.length,
              rowCount: (sectionIndex) {
                final sectionModel = dataSource[sectionIndex];
                return sectionModel.models.length;
              },
              itemBuilder: (context, indexPath) {
                final dataSource = this.dataSource;
                final sectionModel = dataSource[indexPath.section];
                final model = sectionModel.models[indexPath.row];
                bool hasLine = true;
                if (indexPath.section != dataSource.length - 1 &&
                    indexPath.row == sectionModel.models.length - 1) {
                  hasLine = false;
                }
                return _ShopRecordItem(
                  model: model,
                  hasLine: hasLine,
                );
              },
              reusableBuilder: (context, sectionIndex, reusableStyle) {
                if (reusableStyle == FLutterTableViewReusableStyle.footer)
                  return null;
                final sectionModel = dataSource[sectionIndex];
                return _ShopRecordHeader(
                  model: sectionModel,
                  height: sectionIndex % 2 == 0 ? 34 : 68,
                );
              },
              additionalBuilder: (context, index) {
                return _footer();
              },
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final isLoading = ref.watch(this.isLoading);
              final hadLoaded = ref.watch(this.hadLoaded);
              return Visibility(
                visible: isLoading && hadLoaded == false,
                child: child!,
              );
            },
            child: const CupertinoActivityIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    return Consumer(builder: (context, ref, _) {
      final result = ref.watch(hasMore);
      if (result) {
        ref.read(manager.notifier).loadMore();
      }
      return LoadMoreFooter(hasMore: result);
    });
  }
}

class _ShopRecordHeader extends StatelessWidget {
  final double height;
  final ShopRecordSectionModel model;

  const _ShopRecordHeader({
    Key? key,
    required this.model,
    this.height = 34,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(model.date),
      color: Colours.bgGray_,
      padding: const EdgeInsets.only(left: 16),
      alignment: Alignment.centerLeft,
      height: height,
      child: Text(
        model.date,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}

class _ShopRecordItem extends StatelessWidget {
  final ShopRecordModel model;
  final bool hasLine;

  const _ShopRecordItem({
    Key? key,
    required this.model,
    this.hasLine = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(model.toString()),
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  model.isIncome ? "采购订单结算营收" : "提现",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Text(
                model.isIncome ? '+${model.price}' : '-${model.price}',
                style: TextStyle(
                  color: model.isIncome ? Colours.red : Colours.text,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  model.time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colours.textGray,
                  ),
                ),
              ),
              Text(
                '余额${model.balance}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colours.textGray,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          const SizedBox(height: 16),
          Visibility(
            visible: hasLine,
            child: const Divider(),
          ),
        ],
      ),
    );
  }
}
