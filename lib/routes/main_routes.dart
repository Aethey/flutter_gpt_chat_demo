import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../config_dev.dart';

class MainRoutes {
  static String root = AppConfig.root;
  // this is a exp
  static String pageToRedirectTo = AppConfig.pageToRedirectTo;

  static void defineRoutes(FluroRouter router) {
    router.define(pageToRedirectTo, handler: pageToRedirectToHandler);
    // define more routes ta here...
  }
}

var pageToRedirectToHandler =
    Handler(handlerFunc: (BuildContext? context, Map<String, dynamic>? params) {
  //pageToRedirectTo
  return Container();
});

// how to use
// Application.router.navigateTo(context, "/pageToRedirectTo" or pageToRedirectTo,transition: TransitionType.fadeIn(this is animation));
