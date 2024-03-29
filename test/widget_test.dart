import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';
import 'package:hedge_manager/model/pricing_apply.dart';
import 'package:hedge_manager/page/hedge/hedge_helper.dart';

void main() {
  test('model', () {
    List<PricingApply> prices = [PricingApply('2', 'pricingUsingCode', 2, 2, 3, 1)];
    PricingApply? price;
    for (PricingApply e in prices) {
      if (e.pricingId == '1') price = e;
    }
    if (price != null) {
      print(jsonEncode(price));
    } else {
      print('null');
    }
  });

  test('checkNum', () {
    final result = HedgeSumHelper.checkNumFixedIsAllZero(3.000000000000001);
    final result2 = HedgeSumHelper.checkNumFixedIsAllZero(34000.0000000);

    print(result);
    print(result2);
  });
}
