import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/auth.dart';
import 'package:todo_app/screens/auth_screen.dart';
import 'package:todo_app/providers/items_provider.dart';
import 'package:todo_app/screens/splash_screen.dart';
import 'package:todo_app/screens/todo_list_screen.dart';
import 'package:todo_app/utils/app_constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Items>(
            update: (ctx, auth, previousItems) => Items(
              previousItems == null ? [] : previousItems.items,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, child) => MaterialApp(
              title: 'TODO',
              theme: ThemeData(
                primarySwatch: primaryBlack,
                accentColor: Colors.deepOrange,
              ),
              initialRoute: "/",
              home: auth.isAuth
                  ? TodoListScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResutlSnapshot) =>
                          authResutlSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                TodoListScreen.routeName: (context) => TodoListScreen(),
              }),
        ));
  }
}
