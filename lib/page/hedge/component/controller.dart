import 'package:flutter/material.dart';

class HedgeController extends ChangeNotifier {
  String hedgingSchemeId = '0';

  String searchKey = '';

  List<int> status = [0, 1, 2, 3];

  void changeId(String id) {
    hedgingSchemeId = id;
    notifyListeners();
  }

  void changeSearchKey(String? key) {
    searchKey = key ?? '';
    notifyListeners();
  }

  void changeStatus(List<int> statusList) {
    status = statusList;
    notifyListeners();
  }
}

// 策略状态枚举
// 0 — 未生效
// 1 — 进行中
// 2 — 已完成
// 3 — 已冻结
const List<int> strategyStatus = <int>[0, 1, 2, 3];