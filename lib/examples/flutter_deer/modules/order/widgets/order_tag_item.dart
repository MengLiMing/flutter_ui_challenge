import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class OrderTagItem extends StatelessWidget {
  final String date;
  final int orderTotal;

  const OrderTagItem({
    Key? key,
    required this.date,
    required this.orderTotal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 34,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: Color(0x80dce7fa),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 16,
          ),
          const LoadAssetImage(
            'order/icon_calendar',
            width: 14,
            height: 13,
          ),
          const SizedBox(width: 8),
          Text(date),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text('$orderTotal单'),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
