import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/navigator_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/custon_back_button.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';
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
  late final WebViewController webViewController;

  ValueNotifier<double> progress = ValueNotifier(0);

  String get url {
    if (widget.url.startsWith('http') || widget.url.startsWith('https')) {
      return Uri.decodeComponent(widget.url);
    } else {
      return Uri(path: Uri.decodeComponent(widget.url), scheme: 'http')
          .toString();
    }
  }

  @override
  void initState() {
    super.initState();

    webViewController = WebViewController.fromPlatformCreationParams(
        const PlatformWebViewControllerCreationParams());

    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          this.progress.value = progress / 100;
        },
      ));

    webViewController.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: Text(widget.title),
        leading: CustomBackButton(onTap: backAction),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: webViewController),
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
    void pop() {
      NavigatorUtils.pop(context);
    }

    final canGoback = await webViewController.canGoBack();
    if (canGoback) {
      webViewController.goBack();
    } else {
      pop();
    }
  }
}
