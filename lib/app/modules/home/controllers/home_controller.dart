import 'dart:convert';

import 'package:cek_ongkir/app/data/models/ongkir_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxString startProvId = "0".obs;
  RxString startCityId = "0".obs;
  RxString endProvId = "0".obs;
  RxString endCityId = "0".obs;
  RxString kurirId = "0".obs;
  RxInt weight = 1000.obs;

  List<Ongkir> dataOngkir = [];

  cek_ongkir() async {
    if (startProvId != '0' &&
        startCityId != '0' &&
        endProvId != '0' &&
        endCityId != '0' &&
        kurirId != '0' &&
        (weight != 0 || weight != '')) {
      try {
        var response = await Dio().post(
          "https://api.rajaongkir.com/starter/cost",
          data: {
            "origin": startCityId.toString(),
            "destination": endCityId.toString(),
            "weight": weight.toInt(),
            "courier": kurirId.toString(),
          },
          options:
              Options(headers: {'key': '756a38745ce4f0e4c104751072d11dc6'}),
        );
        List ongkir =
            response.data['rajaongkir']['results'][0]['costs'] as List;
        dataOngkir = Ongkir.fromJsonList(ongkir);
        Get.defaultDialog(
            title: "Ongkos Kirim",
            content: Column(
              children: dataOngkir
                  .map((e) => ListTile(
                        title: Text(e.service!.toUpperCase()),
                        subtitle: Text("Rp. "+e.cost![0].value.toString()),
                      ))
                  .toList(),
            ));
      } catch (e) {
        Get.defaultDialog(
            title: "Terjadi kesalahan", middleText: "Server Error");
      }
    } else {
      Get.defaultDialog(
          title: "Terjadi kesalahan", middleText: "Harus diisi semua");
    }
  }
}
