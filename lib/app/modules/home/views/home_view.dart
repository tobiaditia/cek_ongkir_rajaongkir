import 'package:cek_ongkir/app/data/models/city_model.dart';
import 'package:cek_ongkir/app/data/models/province_model.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongkos Kirim'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          DropdownSearch<Province>(
            showSearchBox: true,
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("${item.province}"),
            ),
            dropdownSearchDecoration: InputDecoration(
                labelText: "Provinsi Asal",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                border: OutlineInputBorder()),
            onFind: (text) async {
              var response = await Dio().get(
                  "https://api.rajaongkir.com/starter/province",
                  options: Options(
                      headers: {'key': '756a38745ce4f0e4c104751072d11dc6'}));
              var models =
                  Province.fromJsonList(response.data['rajaongkir']['results']);
              return models;
            },
            onChanged: (value) =>
                controller.startProvId.value = value?.provinceId ?? "0",
          ),
          SizedBox(
            height: 5,
          ),
          DropdownSearch<City>(
            showSearchBox: true,
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("( ${item.type} ) ${item.cityName}"),
            ),
            dropdownSearchDecoration: InputDecoration(
                labelText: "Kota Asal",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                border: OutlineInputBorder()),
            onFind: (text) async {
              var response = await Dio().get(
                  "https://api.rajaongkir.com/starter/city",
                  queryParameters: {"province": "${controller.startProvId}"},
                  options: Options(
                      headers: {'key': '756a38745ce4f0e4c104751072d11dc6'}));
              var models =
                  City.fromJsonList(response.data['rajaongkir']['results']);
              return models;
            },
            onChanged: (value) =>
                controller.startCityId.value = value?.cityId ?? "0",
          ),
          SizedBox(
            height: 20,
          ),
          DropdownSearch<Province>(
            showSearchBox: true,
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("${item.province}"),
            ),
            dropdownSearchDecoration: InputDecoration(
                labelText: "Provinsi Tujuan",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                border: OutlineInputBorder()),
            onFind: (text) async {
              var response = await Dio().get(
                  "https://api.rajaongkir.com/starter/province",
                  options: Options(
                      headers: {'key': '756a38745ce4f0e4c104751072d11dc6'}));
              var models =
                  Province.fromJsonList(response.data['rajaongkir']['results']);
              return models;
            },
            onChanged: (value) =>
                controller.endProvId.value = value?.provinceId ?? "0",
          ),
          SizedBox(
            height: 5,
          ),
          DropdownSearch<City>(
            showSearchBox: true,
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("( ${item.type} ) ${item.cityName}"),
            ),
            dropdownSearchDecoration: InputDecoration(
                labelText: "Kota Tujuan",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                border: OutlineInputBorder()),
            onFind: (text) async {
              var response = await Dio().get(
                  "https://api.rajaongkir.com/starter/city",
                  queryParameters: {"province": "${controller.endProvId}"},
                  options: Options(
                      headers: {'key': '756a38745ce4f0e4c104751072d11dc6'}));
              var models =
                  City.fromJsonList(response.data['rajaongkir']['results']);
              return models;
            },
            onChanged: (value) =>
                controller.endCityId.value = value?.cityId ?? "0",
          ),
          SizedBox(
            height: 20,
          ),
          DropdownSearch<Map<String, dynamic>>(
            showSearchBox: true,
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("${item['name']}"),
            ),
            items: [
              {"code": "jne", "name": "JNE"},
              {"code": "pos", "name": "Pos Indonesia"},
              {"code": "tiki", "name": "TIKI"}
            ],
            dropdownSearchDecoration: InputDecoration(
                labelText: "Kurir",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                border: OutlineInputBorder()),
            dropdownBuilder: (context, selectedItems) =>
                Text("${selectedItems?['name'] ?? 'Pilih Kurir'}"),
            onChanged: (value) =>
                controller.kurirId.value = value?['code'] ?? "0",
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Berat",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => controller.weight.value = int.parse(value),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () => controller.cek_ongkir(),
              child: Text("Cek Ongkir"))
        ],
      ),
    );
  }
}
