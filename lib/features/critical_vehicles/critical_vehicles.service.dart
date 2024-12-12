import 'dart:convert';
import 'package:flutter_wormhole/features/critical_vehicles/critical_vehicle.model.dart';
import 'package:flutter_wormhole/features/critical_vehicles/searchCriticalVehicles.model.dart';
import 'package:flutter_wormhole/shared/models/paintLine.dart';
import 'package:http_interceptor/http/intercepted_http.dart';
import '../../shared/interceptors/keycloak.interceptor.dart';
import '../../shared/models/model.dart';

class CriticalVehiclesService {
  final http = InterceptedHttp.build(interceptors: [
    KeycloakInterceptor(),
  ]);

  Future<List<CriticalVehicle>> getCriticalVehicles(
      SearchCriticalVehicles search) async {
    var r = await http.get(Uri.http('10.0.2.2:8000', 'critical-vehicles', {
      "modelIds": search.modelIds,
      "paintLineIds": search.paintLineIds,
      "modelFilter": search.modelFilter,
      "paintLineFilter": search.paintLineFilter,
      "dateFrom": search.formattedDateFrom(),
      "dateTo": search.formattedDateTo()
    }));
    if (r.statusCode == 200) {
      return jsonDecode(r.body)['data']['critical_vehicles']
          .map((cr) => CriticalVehicle.fromJson(cr))
          .toList()
          .cast<CriticalVehicle>();
    } else {
      print('error critical vehicles');
    }
    return [];
  }

  Future<List<Model>> getModels() async {
    var r = await http.get(Uri.http('10.0.2.2:8000', 'model'));
    if (r.statusCode == 200) {
      return jsonDecode(r.body)['data']
          .map((l) => Model.fromJson(l))
          .toList()
          .cast<Model>();
    } else {
      print('error model');
    }
    return [];
  }

  Future<List<PaintLine>> getLines() async {
    var r = await http.get(Uri.http('10.0.2.2:8000', 'paint-line'));
    if (r.statusCode == 200) {
      return jsonDecode(r.body)['data']
          .map((l) => PaintLine.fromJson(l))
          .toList()
          .cast<PaintLine>();
    } else {
      print('error lines');
    }
    return [];
  }
}
