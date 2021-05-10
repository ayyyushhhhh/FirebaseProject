import 'package:firebase_course/app/home/Jobs/Jobs_page.dart';
import 'package:firebase_course/app/home/account/account_page.dart';
import 'package:firebase_course/app/home/cupertino_home_scaffold.dart';
import 'package:firebase_course/app/home/tab_item.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.job;
  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    }

    setState(() {
      _currentTab = tabItem;
    });
  }

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.job: (_) {
        return JobsPage();
      },
      TabItem.entries: (_) {
        return Container();
      },
      TabItem.account: (_) {
        return AccountPage();
      }
    };
  }

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.job: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !await navigatorKeys[_currentTab].currentState.maybePop();
      },
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectedTab: (TabItem tabItem) {
          _select(tabItem);
        },
        widgetBuilders: widgetBuilders,
        navigationKeys: navigatorKeys,
      ),
    );
  }
}
