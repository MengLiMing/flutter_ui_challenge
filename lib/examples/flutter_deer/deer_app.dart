import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/config_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/deer_storage.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/user_provider.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/loading_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/home/deer_home_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/deer_routers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/deer_theme.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/not_found_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/splash_page.dart';
import 'package:oktoast/oktoast.dart';

class DeerApp extends StatelessWidget {
  static const route = '仿写 github开源项目 flutter_deer UI';
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  DeerApp({Key? key}) : super(key: key) {
    DeerRouters.initRoutes();
  }

  @override
  Widget build(BuildContext context) {
    Widget app = _configApp();

    /// 配置 provider
    app = ProviderScope(child: app);

    /// Toast 配置
    app = OKToast(
      position: ToastPosition.bottom,
      radius: 20,
      textPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      backgroundColor: Colors.black54,
      child: app,
    );

    /// 字体大小不受系统影响
    app = MediaQuery(data: MediaQuery.of(context), child: app);

    return app;
  }

  Widget _configApp() {
    return Consumer(builder: (context, ref, _) {
      final loading = ref.watch(ConfigProviders.configInit);
      return loading.map(data: (_) {
        return _configScreen();
      }, error: (_) {
        return _configScreen();
      }, loading: (_) {
        return const LoadingPage();
      });
    });
  }

  Widget _configScreen() {
    return ProviderScope(
      overrides: [
        UserProviders.userInfo
            .overrideWithValue(DeerUserInfoState(DeerStorage.userInfo)),
      ],
      child: Consumer(
        builder: (context, ref, child) {
          ThemeMode themeMode = ref.watch(ConfigProviders.themeMode);

          Widget content = MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: DeerTheme.getTheme(),
            darkTheme: DeerTheme.getTheme(isDarkMode: true),
            themeMode: themeMode,
            title: 'Deer Demo',
            navigatorKey: navigatorKey,
            onGenerateRoute: DeerRouters.router.generator,
            home: child,
            onUnknownRoute: (settings) {
              return MaterialPageRoute(builder: (context) {
                return const NotFoundPage();
              });
            },
          );
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: content,
          );
        },
        child: _configHome(),
      ),
    );
  }

  Widget _configHome() {
    return Consumer(builder: (context, ref, _) {
      final hadShowGuide = ref.watch(ConfigProviders.hadShowGuide);
      return hadShowGuide ? const DeerHomePage() : const SplashPage();
    });
  }
}
