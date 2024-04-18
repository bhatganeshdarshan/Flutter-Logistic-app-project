import 'package:logisticapp/global.dart';

double? calculateFare(int vehicle) {
  double? amount;
  String? tripDistance = tripDirectionDetailsInfo?.distance_text;
  String distanceWithoutUnit = tripDistance!.replaceAll(" km", "");
  double distance = double.parse(distanceWithoutUnit);
  switch (vehicle) {
    case 0:
      amount = 50.00;
      if (distance < 2.00) {
        return 50.00;
      }
      if (distance >= 2.00 && distance < 8.00) {
        amount = amount + (8.00 * (distance - 1));
        return amount;
      }
      if (distance >= 8.00 && distance < 15.00) {
        amount = amount + (10.00 * (distance - 1));
        return amount;
      }
      if (distance > 15.00) {
        amount = amount + (13.00 * (distance - 1));
        return amount;
      }
      break;

    case 1:
      amount = 181.00;
      if (distance < 1.00) {
        return 181.00;
      }
      if (distance >= 1.00 && distance < 10.00) {
        amount = amount + ((distance - 1) * 20.00);
        return amount;
      }
      if (distance >= 10) {
        amount = amount + ((distance - 1) * 15.00);
        return amount;
      }
      break;
    case 2:
      amount = 205.00;
      if (distance < 1.00) return 205.00;
      if (distance >= 1.00 && distance < 10.00) {
        amount += ((distance - 1) * 24);
        return amount;
      }
      if (distance >= 10.00) {
        amount += ((distance - 1) * 16);
        return amount;
      }
      break;

    case 3:
      amount = 525.00;
      if (distance < 1.00) {
        return 525.00;
      }
      if (distance >= 1.00) {
        amount += ((distance - 1) * 43);
      }
      break;
  }
  return amount;
}
