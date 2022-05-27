import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:hedge_manager/helper/log_utils.dart';

class GetDevicePage extends StatefulWidget {
  const GetDevicePage({Key? key}) : super(key: key);

  @override
  State<GetDevicePage> createState() => _GetDevicePageState();
}

class _GetDevicePageState extends State<GetDevicePage> {
  late WindowsDeviceInfo window;
  late MacOsDeviceInfo mac;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    DeviceInfoPlugin info = DeviceInfoPlugin();
    if (Platform.isWindows) {
      window = await info.windowsInfo;
    } else if (Platform.isMacOS) {
      mac = await info.macOsInfo;
      Log.info(mac.toMap());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Platform.isWindows
            ? Text('${window.toMap()}')
            : Platform.isMacOS
                ? Text('${mac.toMap()}')
                : Text(''),
      ),
    );
  }
}
