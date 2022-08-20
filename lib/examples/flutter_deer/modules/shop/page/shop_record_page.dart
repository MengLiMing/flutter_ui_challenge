// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/shop/widgets/flutter_table_view.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/random_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/custon_back_button.dart';

class ShopRecordPage extends StatefulWidget {
  const ShopRecordPage({Key? key}) : super(key: key);

  @override
  State<ShopRecordPage> createState() => _ShopRecordPageState();
}

class _ShopRecordPageState extends State<ShopRecordPage> {
  List<ShopRecordSectionModel> dataSource = List.generate(
    3,
    (index) => ShopRecordSectionModel(
      data: '时间',
      models: List.generate(
        5,
        (index) => ShopRecordModel(type: '类型$index', price: '100'),
      ),
    ),
  );

  final controller = FlutterTableViewController();

  void randomDelete() {
    if (dataSource.isEmpty) return;

    final randomSection = RandomUtil.number(dataSource.length);
    final sectionModel = dataSource[randomSection];

    if (sectionModel.models.isEmpty) return;
    final randomIndex = RandomUtil.number(sectionModel.models.length);

    List<ShopRecordModel> models = List.from(sectionModel.models);
    models.removeAt(randomIndex);
    dataSource[randomSection] = sectionModel.copyWith(models: models);

    controller.dataChangeWithSection(randomSection, rowCount: models.length,
        removeSection: (index) {
      dataSource.removeAt(randomSection);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: const Text('账户流水'),
        actions: [
          IconButton(
            onPressed: randomDelete,
            icon: const Icon(Icons.delete_rounded),
          ),
        ],
      ),
      body: FlutterTableView(
        controller: controller,
        sectionCount: dataSource.length,
        rowCount: (sectionIndex) {
          final sectionModel = dataSource[sectionIndex];
          return sectionModel.models.length;
        },
        itemBuilder: (context, indexPath) {
          final sectionModel = dataSource[indexPath.section];
          final model = sectionModel.models[indexPath.row];
          return ListTile(
            title: Text(indexPath.toString()),
          );
        },
      ),
    );
  }
}

class ShopRecordSectionModel {
  final String data;
  final List<ShopRecordModel> models;

  ShopRecordSectionModel({
    required this.data,
    required this.models,
  });

  ShopRecordSectionModel copyWith({
    String? data,
    List<ShopRecordModel>? models,
  }) {
    return ShopRecordSectionModel(
      data: data ?? this.data,
      models: models ?? this.models,
    );
  }
}

class ShopRecordModel {
  final String type;
  final String price;

  ShopRecordModel({
    required this.type,
    required this.price,
  });
}
