import 'package:firebase_course/common_widgets/empty_content.dart';
import 'package:flutter/material.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  ListItemsBuilder(
      {Key key, @required this.snapshot, @required this.itemBuilder})
      : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  Widget _buildItems(List<T> items) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return Divider(
          height: 0.5,
        );
      },
      itemCount: items.length + 2,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0 || index == items.length + 1) {
          return Container();
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildItems(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: "Something Went Wrong",
        message: "Try Again later",
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
