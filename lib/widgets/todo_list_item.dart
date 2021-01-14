import 'package:flutter/material.dart';
import 'package:todo_app/providers/item_provider.dart';
import 'package:todo_app/providers/items_provider.dart';
import 'package:todo_app/utils/app_constants.dart';

class TodoListItem extends StatefulWidget {
  const TodoListItem({
    Key key,
    @required this.todoItem,
    @required this.todoItems,
  }) : super(key: key);

  final TodoItem todoItem;
  final Items todoItems;

  @override
  _TodoListItemState createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      secondaryBackground: Container(
        color: Colors.black,
        child: Icon(
          Icons.cancel,
          color: Colors.red,
          size: 40,
        ),
        alignment: Alignment.centerRight,
      ),
      key: UniqueKey(),
      direction: !widget.todoItem.isCompleted
          ? DismissDirection.horizontal
          : DismissDirection.endToStart,
      onDismissed: (direction) async {
        try {
          await widget.todoItems.doSwipeAction(direction, widget.todoItem.id);
          _showSnackBar(
              context,
              direction == DismissDirection.startToEnd
                  ? ITEM_MARKED_COMPLETED
                  : ITEM_DELETED);
        } catch (e) {
          _showSnackBar(context, INTERNET_NOT_CONNECTED);
        }
      },
      background: Container(
        color: Colors.green,
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerLeft,
      ),
      child: widget.todoItem.isCompleted
          ? Card(
              margin: EdgeInsets.all(1),
              clipBehavior: Clip.none,
              color: Colors.black,
              child: ListTile(
                title: Text(
                  widget.todoItem.title,
                  style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough),
                ),
              ),
            )
          : Container(
              height: 50.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.todoItem.randomColor.withOpacity(0.3),
                    widget.todoItem.randomColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Card(
                margin: EdgeInsets.all(0),
                clipBehavior: Clip.none,
                color: Colors.transparent,
                child: ListTile(
                  title: Text(
                    widget.todoItem.title,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
