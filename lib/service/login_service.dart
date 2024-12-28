import 'package:get/get_connect.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:stock_reconcile/model/login_request_model.dart';
import 'package:stock_reconcile/model/login_response_model.dart';

/// LoginService responsible to communicate with web-server
/// via authenticaton related APIs
class LoginService extends GetConnect {
  final String loginUrl =
      'https://erp.nordencommunication.com/api/method/login';

  Future<LoginResponseModel?> fetchLogin(LoginRequestModel model) async {
    var token = '';
    final response = await post(
      loginUrl,
      model.toJson(),
    );
    if (response.statusCode == HttpStatus.ok) {
      response.headers?.forEach((key, value) {
        if (key == 'set-cookie') {
          token = value;
        }
      });
      return LoginResponseModel.fromJson({'token': token});
    } else {
      return null;
    }
  }
}
