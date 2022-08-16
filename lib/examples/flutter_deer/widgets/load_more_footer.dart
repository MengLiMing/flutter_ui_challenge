import 'package:flutter/cupertino.dart';

class LoadMoreFooter extends StatelessWidget {
  final bool hasMore;
  const LoadMoreFooter({
    Key? key,
    required this.hasMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hasMore) {
      return Container(
        height: 50,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('正在加载更多'),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 10,
              height: 10,
              child: CupertinoActivityIndicator(),
            )
          ],
        ),
      );
    } else {
      return Container(
        height: 50,
        alignment: Alignment.center,
        child: const Text('到底了 ~'),
      );
    }
  }
}
