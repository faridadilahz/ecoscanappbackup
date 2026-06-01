export 'cors_image_stub.dart'
    if (dart.library.html) 'cors_image_web.dart'
    if (dart.library.io) 'cors_image_mobile.dart';
