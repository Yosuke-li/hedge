import 'package:flutter/material.dart';
import 'package:hedge_manager/helper/log_utils.dart';

import 'controller.dart';

class HeadViewPage extends StatefulWidget {
  final HedgeController controller;

  const HeadViewPage({required this.controller, Key? key}) : super(key: key);

  @override
  State<HeadViewPage> createState() => _HeadViewPageState();
}

class _HeadViewPageState extends State<HeadViewPage> {
  String select_tab = '全部';

  List<String> tabs = ['全部', '进行中', '已完成', '其他'];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {});
  }

  void changeController() {
    switch (select_tab) {
      case '全部':
        widget.controller.changeStatus([0, 1, 2]);
        break;
      case '进行中':
        widget.controller.changeStatus([0]);
        break;
      case '已完成':
        widget.controller.changeStatus([1]);
        break;
      case '其他':
        widget.controller.changeStatus([2]);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: tabs
                  .map(
                    (e) => InkWell(
                      onTap: () {
                        select_tab = e;
                        setState(() {});
                        changeController();
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        width: 80,
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: select_tab == e
                                ? const Border(
                                    bottom: BorderSide(
                                        width: 4.0, color: Colors.white),
                                  )
                                : null),
                        child: Text(
                          e,
                          style: TextStyle(
                              color: select_tab == e
                                  ? Colors.white
                                  : const Color(0xff79747E)),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(
            width: 300,
            height: 35,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                suffixIcon: const Icon(
                  IconData(0xe632, fontFamily: 'AliIcons'),
                  size: 20,
                ),
                prefixIconConstraints:
                    const BoxConstraints(maxWidth: 25, minWidth: 25),
              ),
              style: const TextStyle(fontSize: 14),
              onChanged: (String? value) {
                widget.controller.changeSearchKey(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
