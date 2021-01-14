import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:refreshable_reorderable_list/refreshable_reorderable_list.dart';
import 'package:todo_app/providers/item_provider.dart';
import 'package:todo_app/providers/items_provider.dart';
import 'package:todo_app/utils/app_constants.dart';
import 'package:todo_app/widgets/todo_list_item.dart';
import 'package:todo_app/widgets/todo_text_form_field.dart';

class TodoListScreen extends StatefulWidget {
  static const routeName = TODO_LIST_SCREEN_ROUTE;

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  var _isEditing = false;
  var _isScrolling = false;

  var _isInit = true;
  var _isLoading = false;

  TextEditingController textEditingController;

  static final ScrollController _scrollController = ScrollController();
  static final FocusNode _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: null);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Items>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((e) {
        _showErrorDialog(INTERNET_NOT_CONNECTED);
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      backgroundColor: primaryBlack,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<Items>(
              builder: (ctxx, todoItems, child) =>
                  NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollStartNotification) {
                    _onStartScroll(notification.metrics, todoItems);
                  } else if (notification is ScrollEndNotification) {
                    _onEndScroll(notification.metrics, todoItems);
                  } else if (notification is ScrollUpdateNotification) {
                    _onUpdateScroll(notification.metrics, todoItems);
                  }
                  return;
                },
                child: todoItems.items.length == 0
                    ? Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: TodoTextFormField(
                            todoItems: todoItems,
                            textFieldFocusNode: _textFieldFocusNode,
                            key: UniqueKey(),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        controller: _scrollController,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: RefreshableReorderableListView(
                            physics: BouncingScrollPhysics(),
                            key: UniqueKey(),
                            children: [
                              if (_isEditing && !_isScrolling)
                                TodoTextFormField(
                                  todoItems: todoItems,
                                  textFieldFocusNode: _textFieldFocusNode,
                                  key: UniqueKey(),
                                ),
                              ..._todoItemsWidgets(todoItems)
                            ],
                            onReorder: todoItems.reorderItems,
                          ),
                        ),
                      ),
              ),
            ),
    );
  }

  _onStartScroll(ScrollMetrics metrics, Items todoItems) {
    _isScrolling = true;
  }

  _onUpdateScroll(ScrollMetrics metrics, Items todoItems) {
    if (_isScrolling &&
        _scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
      _isScrolling = false;
      setState(() {
        _isEditing = true;
      });
    }
  }

  _onEndScroll(ScrollMetrics metrics, Items todoItems) {
    _isScrolling = false;
    _isEditing = false;
  }

  List<Widget> _todoItemsWidgets(Items todoItems) {
    return todoItems.items
        .map(
          (TodoItem todoItem) => TodoListItem(
            todoItem: todoItem,
            key: Key(todoItem.id),
            todoItems: todoItems,
          ),
        )
        .toList();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(ERROR_OCCURED),
              content: Text(message),
              actions: [
                FlatButton(
                  child: Text(OKAY),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }
}
