import 'package:flutter/material.dart';
import 'package:todo_app/providers/items_provider.dart';
import 'package:todo_app/utils/app_constants.dart';

class TodoTextFormField extends StatefulWidget {
  final Items todoItems;
  final FocusNode textFieldFocusNode;
  const TodoTextFormField({
    Key key,
    this.textFieldFocusNode,
    @required this.todoItems,
  }) : super(key: key);

  @override
  _TodoTextFormFieldState createState() => _TodoTextFormFieldState();
}

class _TodoTextFormFieldState extends State<TodoTextFormField> {
  var _isSaved = false;

  @override
  Widget build(BuildContext context) {
    return _isSaved
        ? Center(
            heightFactor: 2.5,
            child: CircularProgressIndicator(),
          )
        : TextFormField(
            textInputAction: TextInputAction.done,
            autofocus: true,
            focusNode: widget.textFieldFocusNode,
            key: widget.key,
            initialValue: '',
            decoration: InputDecoration(
              labelText: ENTER_TODO,
              fillColor: Colors.purple,
              filled: true,
            ),
            onSaved: (value) async {
              setState(() {
                _isSaved = true;
              });
              try {
                await widget.todoItems.addItem(value);
                _showSnackBar(context, ITEM_ADDED);
              } catch (e) {
                _showSnackBar(context, INTERNET_NOT_CONNECTED);
              }
            },
            onFieldSubmitted: (value) async {
              setState(() {
                _isSaved = true;
              });
              try {
                await widget.todoItems.addItem(value);
                _showSnackBar(context, ITEM_ADDED);
              } catch (e) {
                _showSnackBar(context, INTERNET_NOT_CONNECTED);
              }
            },
            style: TextStyle(color: Colors.white),
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
