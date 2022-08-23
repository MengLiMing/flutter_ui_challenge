import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';

class OrderTrackPage extends StatelessWidget {
  final String orderId;

  const OrderTrackPage({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: Text('订单跟踪'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(left: 16),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _timerView();
          } else {
            return _orderStepBuilder(index - 1);
          }
        },
        itemCount: 5,
      ),
    );
  }

  List<_ListStep> get _datas => const [
        _ListStep(desc: '订单已完成', date: '2018/08/30 13:30'),
        _ListStep(desc: '开始配送', date: '2018/08/30 11:30'),
        _ListStep(desc: '等待配送', date: '2018/08/30 9:30'),
        _ListStep(desc: '受到新订单', date: '2018/08/30 9:00'),
      ];

  Widget _timerView() {
    return Container(
      padding: const EdgeInsets.only(top: 21, bottom: 24),
      child: const Text('订单编号：1213124124325'),
    );
  }

  Widget _orderStepBuilder(int index) {
    final data = _datas[index];
    return _ListStepItem(
      data: data,
      isLatest: index == 0,
      isFirst: index == _datas.length - 1,
    );
  }
}

class _ListStepItem extends StatelessWidget {
  final _ListStep data;
  final bool isLatest;
  final bool isFirst;

  const _ListStepItem({
    Key? key,
    required this.data,
    required this.isLatest,
    required this.isFirst,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isLatest ? Colours.appMain : Colours.bgGray,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
              ),
              if (!isFirst)
                Container(
                  margin: const EdgeInsets.only(top: 3, bottom: 3),
                  height: 50,
                  width: 2,
                  color: Colours.bgGray,
                ),
            ],
          ),
          SizedBox(width: 8),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                alignment: Alignment.centerLeft,
                height: 18,
                child: Text(data.desc),
              ),
              Text(data.date),
              SizedBox(height: 4),
            ],
          )),
        ],
      ),
    );
  }
}

class _ListStep {
  final String desc;
  final String date;

  const _ListStep({
    required this.desc,
    required this.date,
  });
}
