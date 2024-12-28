
import 'package:get/get.dart';
import 'package:stock_reconcile/model/recon_list_model.dart';
import 'package:stock_reconcile/service/recon_list_service.dart';

class ReconListController extends GetxController {
  var isLoading = true.obs;
  ReconListService reconService = Get.put(ReconListService());
  var reconList = <ReconModel>[].obs;
  


  @override
  void onInit() {
    fetchRecon();
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
}