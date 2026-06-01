import 'package:flutter/material.dart';

Widget createCorsImage(String url, {BoxFit fit = BoxFit.cover}) {
  return Image.network(url, fit: fit);
}
