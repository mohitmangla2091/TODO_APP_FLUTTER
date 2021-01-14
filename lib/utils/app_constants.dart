import 'package:flutter/material.dart';

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFF000000;

const EMAIL = "email";
const E_MAIL = 'E-Mail';
const NAME = "name";
const PASSWORD = "password";
const PASSWORD_CAMELCASE = "Password";
const BASE_URL = "https://mohitm-task-manager.herokuapp.com";
const USERS_PATH = "/users";
const LOGIN_PATH = "/login";
const TASK_PATH = "/tasks";

const LOGIN_URL = BASE_URL + USERS_PATH + LOGIN_PATH;
const SIGNUP_URL = BASE_URL + USERS_PATH;
const CREATE_TASK_URL = BASE_URL + TASK_PATH;
const GET_TASKS_URL = BASE_URL + TASK_PATH + "?sortBy=createdAt:asc";

const SIGN_IN = "Sign In";
const SIGN_UP = "Sign Up";

const USER_EMAIL = "mohit.mangla@gmail.com";
const USER_PASSWORD = "Test1234@";
Map<String, String> HEADERS = {'Content-Type': 'application/json'};

const TOKEN = 'token';
const AUTHORIZATION = 'Authorization';
const BEARER = 'Bearer';
const USER = 'user';
const USER_ID = 'userId';
const USER_DATA = 'userData';
const TEMP_USER_NAME = 'Mohit';
const CONFIRM_PASSWORD = 'Confirm Password';
const INSTEAD = 'INSTEAD';
const OKAY = 'Okay';
const APP_NAME = 'Todo App';
const LOADING = 'Loading...';
const ENTER_TODO = 'Enter todo Item';
const ITEM_ADDED = 'Item Added!';
const ITEM_MARKED_COMPLETED = 'Item Marked Completed';
const ITEM_DELETED = 'Item Deleted';

//ERRORs
const ERROR_SOMETHING_WENT_WRONG = "Something Went Wrong!";
const ERROR_AUTHENTICATION_FAILED = 'Authentication failed';
const ERROR_AUTH_FAILED_MESSAGE =
    'Count not authenticate you. Please try again later.';
const INVALID_EMAIL = 'Invalid email!';
const ERROR_SHORT_PASSWORD = 'Password is too short!';
const ERROR_PASSWORD_MISMATCH = 'Passwords do not match!';
const ERROR_OCCURED = 'An Error Occured!';
const INTERNET_NOT_CONNECTED = 'Internet not connected';

//ROUTES
const AUTH_ECREEN_ROUTE = '/auth';
const TODO_LIST_SCREEN_ROUTE = '/todo-list-screen';
