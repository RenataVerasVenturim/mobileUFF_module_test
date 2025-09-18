import 'package:get/get.dart';
import '../controller/webview_controller.dart';

class WebViewBinding extends Bindings {
  @override
  void dependencies() {
    // Registra o controller da WebView para ser usado na página
    Get.lazyPut<WebViewController>(() => WebViewController());
  }
}
