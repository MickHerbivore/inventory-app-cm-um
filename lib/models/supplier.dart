import 'dart:convert';

class SupplierList {
  SupplierList({
    required this.listado,
  });

  List<Supplier> listado;

  factory SupplierList.fromJson(String str) => SupplierList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SupplierList.fromMap(Map<String, dynamic> json) => SupplierList(
    listado: List<Supplier>.from(
      json["documents"]?.map((x) => Supplier.fromMap(x["fields"], x["name"])) ?? []
    ),
  );

  Map<String, dynamic> toMap() => {
        "Supplier": List<dynamic>.from(listado.map((x) => x.toMap())),
      };
}

class Supplier {
  Supplier({
    this.id = '',
    required this.supplierName,
    required this.supplierDescription,
    required this.supplierRut,
    required this.supplierAddress,
    required this.supplierPhone,
    required this.supplierEmail,
  });

  String id;
  String supplierName;
  String supplierDescription;
  String supplierRut;
  String supplierAddress;
  String supplierPhone;
  String supplierEmail;

  factory Supplier.fromJson(String str) => Supplier.fromMap(json.decode(str), '');

  String toJson() => json.encode(toMap());

  factory Supplier.fromMap(Map<String, dynamic> json, String name) => Supplier(
        id: name.split('/').last,
        supplierName: json["supplierName"]["stringValue"],
        supplierDescription: json["supplierDescription"]["stringValue"],
        supplierRut: json["supplierRut"]["stringValue"],
        supplierAddress: json["supplierAddress"]["stringValue"],
        supplierPhone: json["supplierPhone"]["stringValue"],
        supplierEmail: json["supplierEmail"]["stringValue"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "supplierName": supplierName,
        "supplierDescription": supplierDescription,
        "supplierRut": supplierRut,
        "supplierAddress": supplierAddress,
        "supplierPhone": supplierPhone,
        "supplierEmail": supplierEmail,
      };

  Supplier copy() => Supplier(
      id: id,
      supplierName: supplierName,
      supplierDescription: supplierDescription,
      supplierRut: supplierRut,
      supplierAddress: supplierAddress,
      supplierPhone: supplierPhone,
      supplierEmail: supplierEmail,
  );
}
