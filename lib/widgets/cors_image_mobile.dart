import 'package:flutter/material.dart';

Widget createCorsImage(String url, {BoxFit fit = BoxFit.cover}) {
  return Image.network(
    url,
    fit: fit,
    errorBuilder: (context, error, stackTrace) => Container(
      color: Colors.grey[200],
      child: const Icon(Icons.broken_image, color: Colors.black26),
    ),
  );
}
