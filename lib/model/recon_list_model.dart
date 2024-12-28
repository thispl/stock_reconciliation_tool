// To parse this JSON data, do
//
//     final reconModel = reconModelFromJson(jsonString);

import 'dart:convert';


List<ReconModel> reconModelFromJson(String str) =>
    List<ReconModel>.from(json.decode(str).map((x) => ReconModel.fromJson(x)));

String reconModelToJson(List<ReconModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReconModel {
  String name;
  DateTime creation;
  // String company;
  // String warehouse;
  // String item;
  // double stock_qty;
  // double physical_qty;
  // // String qty_addedremoved;
  // String rack;


  ReconModel({
    required this.name,
    required this.creation,
    // required this.company,
    // required this.warehouse,
    
    // required this.item,
    // required this.stock_qty,
    // required this.physical_qty,
    // required this.rack,
    // required this.qty_addedremoved,
  });

  factory ReconModel.fromJson(Map<String, dynamic> json) => ReconModel(
        name: json["name"],
        creation: DateTime.parse(json["creation"]),
        // company: json["company"],
        // warehouse: json["warehouse"],
        
        // item: json["item"],
        // stock_qty: json["stock_qty"],
        // physical_qty: json["physical_qty"],
        // rack: json["rack"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        // "posting_date":
        "creation":
            "${creation.year.toString().padLeft(4, '0')}-${creation.month.toString().padLeft(2, '0')}-${creation.day.toString().padLeft(2, '0')}",
        // "company": company,
        // "warehouse": warehouse,
        
        // "item": item,
        // "stock_qty": stock_qty.toString(),
        // // "qty_addedremoved": qty_addedremoved,
        // "physical_qty": physical_qty.toString(),
        // "rack": rack,
      };
}
