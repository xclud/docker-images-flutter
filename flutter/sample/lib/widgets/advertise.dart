import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:novinpay/models/GetBannersResponse.dart' as resp;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';

final List<resp.Banner> _images = [resp.Banner(filename: null, image: null)];
bool _loadedFromServer = false;

Future<void> _getBannerList() async {
  if (_loadedFromServer == true) {
    return;
  }

  var data = await nh.novinPay.application.getBanners();

  if (data.hasErrors()) {
    return;
  }

  _images.clear();
  for (final dir in data.content.directories) {
    for (final bnr in dir.banners) {
      _images.add(bnr);
    }
  }

  _loadedFromServer = true;
}

class AdvertiseBanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AdvertiseBannerState();
  }
}

class _AdvertiseBannerState extends State<AdvertiseBanner> {
  int _current = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _getBannerList();
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget swiper() => Stack(
          fit: StackFit.expand,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                  aspectRatio: 2.75,
                  viewportFraction: 1,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: _images
                  .map((image) => InkWell(
                        onTap: () => _tryLaunchWithFilename(image.filename),
                        child: _buildImage(image.image),
                      ))
                  .toList(),
            ),
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _images.map((image) {
                    int index = _images.indexOf(image);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index
                            ? Color.fromRGBO(0, 0, 0, 0.9)
                            : Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );

    Widget single() => InkWell(
          onTap: () => _tryLaunchWithFilename(_images[0].filename),
          child: _buildImage(_images[0].image),
        );

    if (_images.isEmpty) {
      return AspectRatio(
        aspectRatio: 2.75,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 2.75,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _images.length == 1 ? single() : swiper(),
      ),
    );
  }

  Widget _buildImage(Uint8List image) {
    if (image == null) {
      return Image.asset(
        'assets/advertise/default.jpg',
        fit: BoxFit.cover,
      );
    }

    return Image.memory(
      image,
      fit: BoxFit.cover,
    );
  }

  void _tryLaunchWithFilename(String filename) async {
    if (filename == null || filename.isEmpty) {
      return;
    }

    if (!filename.startsWith('www.')) {
      return;
    }

    final http = 'http://$filename';

    final url = Uri.tryParse(http);
    if (url != null) {
      Utils.customLaunch(context, http);
    }
  }
}
