import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/custon_back_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const WebViewPage({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController? webViewController;

  ValueNotifier<double> progress = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    if (!kIsWeb && Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  String get url {
    if (widget.url.startsWith('http') || widget.url.startsWith('https')) {
      return Uri.decodeComponent(widget.url);
    } else {
      return Uri(path: Uri.decodeComponent(widget.url), scheme: 'http')
          .toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: CustomBackButton(onTap: backAction),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            allowsInlineMediaPlayback: true,
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onProgress: (value) {
              progress.value = value / 100;
            },
          ),
          ValueListenableBuilder(
              valueListenable: progress,
              builder: (context, value, _) {
                if (value == 1) {
                  return const SizedBox.shrink();
                } else {
                  return LinearProgressIndicator(
                    value: progress.value,
                    backgroundColor: Colors.transparent,
                    color: Colours.appMain,
                    minHeight: 2,
                  );
                }
              }),
        ],
      ),
    );
  }

  void backAction() async {
    final controller = webViewController;
    if (controller == null) {
      NavigatorUtils.pop(context);
      return;
    }
    final canGoback = await controller.canGoBack();
    if (canGoback) {
      controller.goBack();
    } else {
      NavigatorUtils.pop(context);
    }
  }
}
