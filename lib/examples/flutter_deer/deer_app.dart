import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/config_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/deer_storage.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/common/user_provider.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/home/deer_main_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/home/loading_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/home/splash_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/deer_routers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/deer_theme.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/routers/not_found_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
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
      position: ToastPosition.center,
      radius: 20,
      textPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      backgroundColor: Colors.black87,
      child: app,
    );

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
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashPage(),
        );
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
            darkTheme: DeerTheme.getTheme(isDarkMode: false), // 未做适配
            themeMode: themeMode,
            title: 'Deer Demo',
            navigatorKey: navigatorKey,
            onGenerateRoute: DeerRouters.router.generator,
            home: child,
            builder: (context, child) {
              ScreenUtils.config(context);
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: ScreenUtils.scale,
                ),
                child: child!,
              );
            },
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
      return hadShowGuide ? const DeerMainPage() : const DeerGuidePage();
    });
  }
}
