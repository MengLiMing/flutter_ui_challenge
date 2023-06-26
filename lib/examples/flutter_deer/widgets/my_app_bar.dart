import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/custon_back_button.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final double? elevation;
  final bool automaticallyImplyLeading;
  final double? titleSpacing;

  const MyAppBar({
    Key? key,
    this.title,
    this.leading,
    this.actions,
    this.elevation,
    this.titleSpacing,
    this.automaticallyImplyLeading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;

    Widget? backButton;
    if (automaticallyImplyLeading && canPop) {
      backButton = const CustomBackButton();
    }
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: AppBar(
        titleSpacing: titleSpacing,
        automaticallyImplyLeading: automaticallyImplyLeading,
        elevation: elevation,
        title: title,
        leading: leading ?? backButton,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(ScreenUtils.navBarHeight);
}
