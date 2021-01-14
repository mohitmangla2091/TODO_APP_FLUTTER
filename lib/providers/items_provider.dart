import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/providers/item_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:todo_app/utils/app_constants.dart';
import 'package:todo_app/utils/unitily.dart';

class Items with ChangeNotifier {
  List<TodoItem> _items = [];

  Items(this._items);

  List<TodoItem> _sortedItems = [];

  List<TodoItem> get items {
    _sortedItems = [];
    var counter = 0;
    _items.forEach((element) {
      if (!element.isCompleted) {
        _sortedItems.insert(_sortedItems.length - counter, element);
      } else {
        counter++;
        _sortedItems.insert(_sortedItems.length, element);
      }
    });
    return [..._sortedItems];
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    var url = GET_TASKS_URL;

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    var headers = HEADERS;
    headers['Authorization'] = 'Bearer ${extractedUserData['token']}';

    final isInternetConnected = await Util.checkInternet();
    if (!isInternetConnected) {
      notifyListeners();
      throw Exception(INTERNET_NOT_CONNECTED);
    }
    try {
      final response = await http.get(
        url,
        headers: HEADERS,
      );
      final extractedData = json.decode(response.body) as List<dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<TodoItem> loadedProducts = [];
      extractedData.forEach((taskData) {
        loadedProducts.add(TodoItem(
          id: taskData['_id'],
          title: taskData['description'],
          time: taskData['createdAt'],
          isCompleted: taskData['completed'],
        ));
      });
      loadedProducts.forEach((element) {
        print(DateTime.parse(element.time));
      });
      loadedProducts.sort(
          (a, b) => DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addItem(String title) async {
    final isInternetConnected = await Util.checkInternet();
    if (!isInternetConnected) {
      notifyListeners();
      throw Exception(INTERNET_NOT_CONNECTED);
    }
    final url = CREATE_TASK_URL;
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'description': title,
            'completed': false,
          },
        ),
        headers: HEADERS,
      );
      final newItem = TodoItem(
        title: title,
        id: json.decode(response.body)['name'],
      );
      _items.insert(0, newItem);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteItem(String id) async {
    final url = CREATE_TASK_URL + '/${id}';
    final existingProductIndex = _items.indexWhere((prod) {
      return prod.id == id;
    });
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final isInternetConnected = await Util.checkInternet();
    if (!isInternetConnected) {
      notifyListeners();
      throw Exception(INTERNET_NOT_CONNECTED);
    }
    final response = await http.delete(
      url,
      headers: HEADERS,
    );

    if (response.statusCode != 200) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void reorderItems(int oldIndex, int newIndex) {
    TodoItem old = _items[oldIndex];
    if (oldIndex > newIndex) {
      for (int i = oldIndex; i > newIndex; i--) {
        _items[i] = _items[i - 1];
      }
      _items[newIndex] = old;
    } else {
      for (int i = oldIndex; i < newIndex - 1; i++) {
        _items[i] = _items[i + 1];
      }
      _items[newIndex - 1] = old;
    }
    notifyListeners();
  }

  void doSwipeAction(DismissDirection direction, String id) async {
    final isInternetConnected = await Util.checkInternet();
    if (!isInternetConnected) {
      notifyListeners();
      throw Exception(INTERNET_NOT_CONNECTED);
    }
    final swipedItem = _items.firstWhere((item) => item.id == id);
    if (swipedItem == null) {
      return;
    }
    if (direction == DismissDirection.startToEnd) {
      swipedItem.markCompleted();
    } else if (direction == DismissDirection.endToStart) {
      deleteItem(id);
    }
    notifyListeners();
  }
}
