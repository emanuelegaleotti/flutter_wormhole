import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wormhole/features/critical_vehicles/critical_vehicle.model.dart';
import 'package:flutter_wormhole/features/critical_vehicles/searchCriticalVehicles.model.dart';
import 'package:flutter_wormhole/shared/models/paintLine.dart';
import 'package:multiselect/multiselect.dart';

import '../../core/bottomNavigation.dart';
import '../../core/header.dart';
import 'package:intl/intl.dart';

import '../../shared/models/model.dart';
import 'critical_vehicles.service.dart';

class CriticalVehicles extends StatefulWidget {
  const CriticalVehicles({super.key});

  @override
  State<CriticalVehicles> createState() => _CriticalVehicles();
}

class _CriticalVehicles extends State<CriticalVehicles> {
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateTo = TextEditingController();
  CriticalVehiclesService service = CriticalVehiclesService();
  List<Model> models = [];
  List<PaintLine> paintLines = [];
  List<String> selectedPaintLineIds = [];
  List<String> selectedModelIds = [];
  late SearchCriticalVehicles s = SearchCriticalVehicles(
      dateFrom: DateTime.now(),
      dateTo: DateTime.now(),
      modelIds: [],
      paintLineIds: [],
      modelFilter: '',
      paintLineFilter: '');
  List<TableRow> tableBody = [];

  Future<void> setDateTo(TextEditingController i, BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        s.dateTo = pickedDate;
        i.text = formattedDate;
      });
    }
  }

  Future<void> setDateFrom(
      TextEditingController i, BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        s.dateFrom = pickedDate;
        i.text = formattedDate;
      });
    }
  }

  getModels() async {
    List<Model> l = await service.getModels();
    setState(() {
      models = l;
    });
  }

  getLines() async {
    List<PaintLine> l = await service.getLines();
    setState(() {
      paintLines = l;
    });
  }

  getCriticalVehicles() async {
    List<CriticalVehicle> l = await service.getCriticalVehicles(s);
    setState(() {
      tableBody = l
          .map((cv) => TableRow(children: [
                TableCell(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(cv.id))),
                TableCell(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${cv.brand} ${cv.version}'))),
                TableCell(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text(cv.paint_line, textAlign: TextAlign.center))),
                TableCell(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(cv.serial)))
              ]))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getModels();
    getLines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Header(),
        bottomNavigationBar: const BottomNavigation(),
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
                child: Column(children: [
              Row(
                children: [
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TextFormField(
                            controller: dateFrom,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Date from:',
                            ),
                            onTap: () {
                              setDateFrom(dateFrom, context);
                            },
                          ))),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextFormField(
                            controller: dateTo,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Date to:',
                            ),
                            onTap: () {
                              setDateTo(dateTo, context);
                            },
                          )))
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                                labelText: 'Model filter'),
                            items: const [
                              DropdownMenuItem(
                                value: 'NM',
                                child: Text('All models'),
                              ),
                              DropdownMenuItem(
                                value: 'YM',
                                child: Text('Same model'),
                              ),
                            ],
                            onChanged: (String? id) {
                              setState(() {
                                s.modelFilter = id;
                              });
                            })),
                  ),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                  labelText: 'Paint line filter'),
                              items: const [
                                DropdownMenuItem(
                                  value: 'NL',
                                  child: Text('All lines'),
                                ),
                                DropdownMenuItem(
                                  value: 'YL',
                                  child: Text('Same line'),
                                ),
                              ],
                              onChanged: (String? id) {
                                setState(() {
                                  s.paintLineFilter = id;
                                });
                              })))
                ],
              ),
              Row(children: [
                Expanded(
                    child: DropDownMultiSelect(
                  decoration: const InputDecoration(labelText: 'Models'),
                  options:
                      models.map((m) => '${m.brand} ${m.version}').toList(),
                  selectedValues: selectedModelIds,
                  onChanged: (List<dynamic> l) {
                    setState(() {
                      s.modelIds = l
                          .map((name) => models
                              .firstWhere(
                                  (m) => '${m.brand} ${m.version}' == name)
                              .id)
                          .toList();
                    });
                  },
                )),
              ]),
              Row(children: [
                Expanded(
                    child: DropDownMultiSelect(
                  decoration: const InputDecoration(labelText: 'Paint lines'),
                  options: paintLines.map((l) => l.code).toList(),
                  selectedValues: selectedPaintLineIds,
                  onChanged: (List<dynamic> l) {
                    setState(() {
                      s.paintLineIds = l
                          .map((c) =>
                              paintLines.firstWhere((l) => l.code == c).id)
                          .toList();
                    });
                  },
                )),
              ]),
              Row(children: [
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: FilledButton(
                            onPressed: () {
                              getCriticalVehicles();
                            },
                            child: const Text('Cerca'))))
              ])
            ])),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Table(
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  border: TableBorder.all(),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    const TableRow(children: [
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('ID',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Model',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Paint line',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )),
                      TableCell(
                          verticalAlignment: TableCellVerticalAlignment.top,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Serial',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          )),
                    ]),
                    ...tableBody
                  ],
                )),
          )
        ])));
  }
}
