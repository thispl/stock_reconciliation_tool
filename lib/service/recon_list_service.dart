import 'dart:convert';

import 'package:get/get_connect.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:get/get.dart';
import 'package:stock_reconcile/model/recon_list_model.dart';
import 'package:stock_reconcile/utils/authentication_manager.dart';
import 'package:stock_reconcile/utils/cache_manager.dart';
import 'package:stock_reconcile/utils/globals.dart';

class ReconListService extends GetConnect with CacheManager {
  final AuthenticationManager _authManager = Get.find();
  final String reconUrl =
      '${Globals.url}/api/resource/Stock Analysis?fields=["name","creation"]&order_by=creation%20desc';

  Future<List<ReconModel>?> fetchRecon() async {
    var response = await get(reconUrl, headers: {
      'Accept': 'application/json',
      'Cookie': getToken().toString()
    });
    print(response.body);
    if (response.statusCode == HttpStatus.ok) {
      var dataList = response.body['data'];
      return reconModelFromJson(json.encode(dataList));
    } else {
      if (response.statusCode == HttpStatus.forbidden) {
        if (response.body['session_expired'] == 1) {
          _authManager.logOut();
        }
      } else {
        //show error message
        Get.snackbar('Error', response.statusCode.toString());
      }
    }
    return [];
  }
}