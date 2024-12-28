import 'dart:convert';

import 'package:get/get_connect.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:get/get.dart';
import 'package:stock_reconcile/model/recon_list_model.dart';
import 'package:stock_reconcile/utils/authentication_manager.dart';
import 'package:stock_reconcile/utils/cache_manager.dart';
import 'package:stock_reconcile/utils/globals.dart';

class ReconService extends GetConnect with CacheManager {
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

  Future checkWarehouse(String warehouse) async {
    String url =
        '${Globals.url}/api/resource/Rack?filters=[["name","=","$warehouse"]]';
    var response = await get(url, headers: {
      'Accept': 'application/json',
      'Cookie': getToken().toString()
    });

    if (response.statusCode == HttpStatus.ok) {
      var dataList = response.body['data'];
      return dataList.length;
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
  }

  Future checkItem(String item) async {
    String url =
        '${Globals.url}/api/resource/Item?filters=[["name","=","$item"]]';
    var response = await get(url, headers: {
      'Accept': 'application/json',
      'Cookie': getToken().toString()
    });

    if (response.statusCode == HttpStatus.ok) {
      var dataList = response.body['data'];
      return dataList.length;
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
  }

  Future<String> updatePhysicalQty(
      String warehouse, String itemCode, double stockQty, double physicalQty, String stock_analysis) async {
    String url = '${Globals.url}/api/method/norden.api.update_stock_qty';

    var body = json.encode({
      "rack": warehouse,
      "item_code": itemCode,
      'stockQty': stockQty,
      "physical_qty": physicalQty,
      "stock_analysis":stock_analysis
    });
    var response = await post(url, body, headers: {
      'Accept': 'application/json',
      'Cookie': getToken().toString(),
    });
    if (response.statusCode == HttpStatus.ok) {
      var dataList = response.body;
      print(dataList);
      return dataList['message'];
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

    return 'Updated';
  }

  Future getStockQty(String itemCode, String warehouse) async {
    String url =
        '${Globals.url}/api/resource/Stock Ledger Entry?filters=[["item_code","=","$itemCode"],["warehouse","=","Main Stores - NCME"],["rack","=","$warehouse"]]&fields=["qty_after_transaction"]&limit=1&order_by=creation DESC';

    var response = await get(url, headers: {
      'Accept': 'application/json',
      'Cookie': getToken().toString()
    });
    if (response.statusCode == HttpStatus.ok) {
      var dataList = response.body['data'];
      if (dataList.length > 0) {
        return dataList[0]['qty_after_transaction'];
      } else {
        return 0;
      }
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
  }
  Future getitemname(String itemCode, String warehouse) async {
    String url =
        '${Globals.url}/api/resource/Item?filters=[["item_code","=","$itemCode"]]&fields=["item_name"]';

    var response = await get(url, headers: {
      'Accept': 'application/json',
      'Cookie': getToken().toString()
    });
    if (response.statusCode == HttpStatus.ok) {
      var dataList = response.body['data'];
      if (dataList.length > 0) {
        return dataList[0]['item_name'];
      } else {
        return null;
      }
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
  }
}
