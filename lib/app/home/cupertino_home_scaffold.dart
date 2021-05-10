import 'package:firebase_course/app/home/tab_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigationKeys;

  const CupertinoHomeScaffold(
      {Key key,
      @required this.currentTab,
      @required this.onSelectedTab,
      @required this.widgetBuilders,
      @required this.navigationKeys})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            _buildItem(TabItem.job),
            _buildItem(TabItem.entries),
            _buildItem(TabItem.account),
          ],
          onTap: (index) => onSelectedTab(TabItem.values[index]),
        ),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(
            builder: (BuildContext context) {
              final item = TabItem.values[index];
              return CupertinoTabView(
                navigatorKey: navigationKeys[index],
                builder: (BuildContext context) =>
                    widgetBuilders[item](context),
              );
            },
          );
        });
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    final color = currentTab == tabItem ? Colors.indigo : Colors.grey;
    return BottomNavigationBarItem(
        icon: Icon(
          itemData.icon,
          color: color,
        ),
        label: itemData.title);
  }
}
