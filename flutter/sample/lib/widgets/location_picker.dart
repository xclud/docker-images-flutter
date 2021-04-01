import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:location/location.dart';
import 'package:map/map.dart' as map;
import 'package:novinpay/services/platform_helper.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';

Widget _buildTile(BuildContext context, int x, int y, int z) {
  final url =
      'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

  return CachedNetworkImage(
    imageUrl: url,
    fit: BoxFit.cover,
  );
}

class LocationPicker extends StatefulWidget {
  LocationPicker({this.initialLocation, this.initialZoom = 14});

  final LatLng initialLocation;
  final double initialZoom;

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  Offset _dragStart;
  double _scaleStart = 1.0;
  final _location = Location();
  final _controller = map.MapController(
    location: LatLng(35.68, 51.41),
  );
  LatLng _currentLocation;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getUserFixedLocation();
      _getLocationInBackground();
    });

    _controller.zoom = widget.initialZoom;

    super.initState();
  }

  void _getLocationInBackground() async {
    if (getPlatform() == PlatformType.web) {
      _updateLocationInBackground();
      return;
    }

    bool serviceEnabled = await _location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    var permissionGranted = await _location.hasPermission();

    if (permissionGranted != PermissionStatus.granted) {
      permissionGranted = await _location.requestPermission();

      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _updateLocationInBackground();
  }

  void _updateLocationInBackground() async {
    while (mounted) {
      try {
        final event = await _location.getLocation();
        _currentLocation = LatLng(event.latitude, event.longitude);
      } on Object {
        //
      }

      await Future.delayed(Duration(seconds: 1));
    }
  }

  void _onDoubleTap() {
    _controller.zoom += 0.5;
  }

  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      _controller.zoom += 0.02;
    } else if (scaleDiff < 0) {
      _controller.zoom -= 0.02;
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart;
      _dragStart = now;
      _controller.drag(diff.dx, diff.dy);
    }
  }

  void _getUserFixedLocation() {
    if (widget.initialLocation != null) {
      _controller.center = widget.initialLocation;
      _currentLocation = widget.initialLocation;
    }
  }

  void _getCurrentLocation() async {
    if (_currentLocation != null) {
      setState(() {
        _controller.center = _currentLocation;
        _controller.zoom = 16;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('نقشه'),
      body: Split(
        child: GestureDetector(
          onDoubleTap: _onDoubleTap,
          onScaleStart: _onScaleStart,
          onScaleUpdate: _onScaleUpdate,
          onScaleEnd: (details) {},
          child: Stack(
            children: [
              map.Map(
                controller: _controller,
                builder: _buildTile,
              ),
              Center(
                child: Container(
                  padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 40),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: Colors.red,
                    size: 50,
                  ),
                ),
              ),
              PositionedDirectional(
                child: ConfirmButton(
                  child: CustomText(
                    strings.action_ok,
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(_controller.center);
                  },
                ),
                start: 24.0,
                end: 24.0,
                bottom: 24.0,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsetsDirectional.fromSTEB(24, 0, 16, 96),
        child: FloatingActionButton(
          onPressed: isSecureEnvironment ? _getCurrentLocation : null,
          backgroundColor: isSecureEnvironment ? null : Colors.grey.shade500,
          tooltip: 'موقعیت من',
          child: Icon(Icons.my_location),
        ),
      ),
    );
  }
}
