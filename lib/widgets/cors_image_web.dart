// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:ui_web' as ui_web;
import 'dart:html' as html;
import 'package:flutter/material.dart';

Widget createCorsImage(String url, {BoxFit fit = BoxFit.cover}) {
  final String viewType = 'cors-img-${url.hashCode}';
  
  // Register the view factory for Web Image element
  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    return html.ImageElement()
      ..src = url
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.border = 'none'
      ..style.objectFit = fit == BoxFit.cover ? 'cover' : 'contain';
  });

  return HtmlElementView(viewType: viewType);
}
