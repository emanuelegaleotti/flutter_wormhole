import 'package:intl/intl.dart';

class SearchCriticalVehicles {
  DateTime dateFrom;
  DateTime dateTo;
  List<String> modelIds;
  List<String> paintLineIds;
  String? modelFilter;
  String? paintLineFilter;

  SearchCriticalVehicles(
      {required this.dateFrom,
      required this.dateTo,
      required this.modelIds,
      required this.paintLineIds,
      required this.modelFilter,
      required this.paintLineFilter});

  formattedDateTo() {
    return DateFormat('yyyy-MM-dd').format(dateTo);
  }

  formattedDateFrom() {
    return DateFormat('yyyy-MM-dd').format(dateFrom);
  }
}
