import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stock_reconcile/model/recon_list_model.dart';
import 'package:stock_reconcile/service/reconciliation_service.dart';
import 'package:stock_reconcile/views/home_view.dart';
import 'package:stock_reconcile/views/recon_entry.dart';

class ReconController extends GetxController {
  // var isSubmitted = false.obs; // Add this line
  var physicalQty = TextEditingController().obs;
  var isSubmitClicked = false.obs;
  var warehouse = ''.obs;
  var bin = ''.obs;
  var stockQty = 0.0.obs;
  var itemName = ''.obs;
  var is_valid_warehouse = false.obs;
  var is_valid_item = false.obs;
  var item_code = ''.obs;
  var isLoading = true.obs;
  ReconService reconService = Get.put(ReconService());
  var reconList = <ReconModel>[].obs;
  var scanned_text = ''.obs;
  var message = ''.obs;
  void updatePhysicalQty(String warehouse, String itemCode, double stockQty,
      double physicalQty, String stock_analysis) async {
    // Call your service here
    var responseMessage = await ReconService().updatePhysicalQty(
        warehouse, itemCode, stockQty, physicalQty, stock_analysis);
    message.value = responseMessage;
    isSubmitClicked.value = true;
    Get.to(ReconEntry());
    // isSubmitted.value = true;
  }

  @override
  void onInit() {
    fetchRecon();
    // is_valid_item.value = false;
    // is_valid_warehouse.value = false;
    super.onInit();
  }

  Future fetchRecon() async {
    try {
      var recons = await reconService.fetchRecon();
      if (recons != null) {
        reconList.value = recons;
      }
    } finally {
      isLoading(false);
    }
  }

  void scanBarcode(String scantype, String scannedData) async {
    try {
      // var result = await BarcodeScanner.scan();
      if (scantype == 'warehouse') {
        // warehouse.value = result.rawContent;
        var isValid = await reconService.checkWarehouse(scannedData);
        if (isValid == 1) {
          is_valid_warehouse(true);
        } else {
          is_valid_warehouse(false);
        }
        print(isValid);
      } else if (scantype == 'item') {
        // item_code.value = result.rawContent;
        var isValid = await reconService.checkItem(scannedData);
        if (isValid == 1) {
          is_valid_item(true);
          stockQty.value =
              await reconService.getStockQty(item_code.value, warehouse.value);
          itemName.value =
              await reconService.getitemname(item_code.value, warehouse.value);
        } else {
          is_valid_item(false);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
