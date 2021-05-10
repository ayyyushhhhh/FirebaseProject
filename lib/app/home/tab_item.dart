import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum TabItem { job, entries, account }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData({@required this.title, @required this.icon});

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.job: TabItemData(icon: Icons.work, title: 'Job'),
    TabItem.entries: TabItemData(icon: Icons.view_headline, title: 'Job'),
    TabItem.account: TabItemData(icon: Icons.person, title: 'Account'),
  };
}
