import 'package:get/get.dart';
//import 'package:webview_flutter/webview_flutter.dart';

class WebViewController extends GetxController {
  late final String url;
  late final WebViewController wvc;

  @override
  void onInit() {
    super.onInit();
    url = Get.arguments['url'];
    wvc = WebViewController();
     // ..setJavaScriptMode(JavaScriptMode.unrestricted)
     // ..loadRequest(Uri.parse(url));
  }

}


