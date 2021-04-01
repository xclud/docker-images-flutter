import 'package:image/image.dart';

List<int> ensureImageSize(List<int> data) {
  Image image = decodeImage(data);
  if (image.width > 1024) {
    image = copyResize(image, width: 1024);
  }

  if (image.height > 1024) {
    image = copyResize(image, height: 1024);
  }

  return encodeJpg(image);
}
