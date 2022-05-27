import 'package:flutter/material.dart';
import 'package:hedge_manager/helper/event_bus_helper.dart';
import 'package:hedge_manager/helper/global/setting.dart';
import 'package:hedge_manager/page/hedge/component/controller.dart';

import 'package:hedge_manager/page/hedge/component/page_view.dart';
import 'package:hedge_manager/page/hedge/component/head_view.dart';
import 'package:hedge_manager/page/hedge/component/list_view.dart';

import '../../helper/log_utils.dart';

class HedgePage extends StatefulWidget {
  const HedgePage({Key? key}) : super(key: key);

  @override
  State<HedgePage> createState() => _HedgePageState();
}

class _HedgePageState extends State<HedgePage> {
  HedgeController controller = HedgeController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _onListener();
  }

  void _onListener() {
    EventBusHelper.listen<Event>((event) {
      if (event.isReconnect == true) {
        controller = HedgeController();
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          child: PageViewPage(
            key: Key(controller.hashCode.toString()),
            controller: controller,
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 15, left: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              border: Border.all(
                color: const Color(0xffCAC4D0),
                width: 0.5,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                HeadViewPage(
                  key: Key(controller.hashCode.toString()),
                  controller: controller,
                ),
                Expanded(
                  child: RepaintBoundary(
                    child: ListViewPage(
                      key: Key(controller.hashCode.toString()),
                      controller: controller,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
