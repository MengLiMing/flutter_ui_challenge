import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/change_app_page.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/my_app_bar.dart';
import 'package:flutter_ui_challenge/examples/ui_chanllenge/routes.dart';
import 'package:flutter_ui_challenge/examples/ui_chanllenge/theme.dart';

class FlutterChallengeApp extends StatelessWidget {
  const FlutterChallengeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      darkTheme: Themes.lightTheme,
      home: const HomePage(),
      routes: routes,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: const Text('HomePage'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const ChangeAppPage();
              }));
            },
            icon: const Icon(Icons.change_circle_rounded),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.only(top: 10),
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
        itemBuilder: (context, index) {
          return HomeListItem(
            routeName: routes.keys.elementAt(index),
          );
        },
        itemCount: routes.length,
      ),
    );
  }
}

class HomeListItem extends StatelessWidget {
  final String routeName;

  const HomeListItem({
    Key? key,
    required this.routeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(routeName),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        constraints: const BoxConstraints(minHeight: 60),
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset.zero,
              blurRadius: 2,
            ),
          ],
        ),
        child: Text(
          routeName,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
