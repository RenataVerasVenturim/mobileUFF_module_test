import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ClassroomWebViewPage extends StatefulWidget {
  final String url;
  const ClassroomWebViewPage({super.key, required this.url});

  @override
  State<ClassroomWebViewPage> createState() => _ClassroomWebViewPageState();
}

class _ClassroomWebViewPageState extends State<ClassroomWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
            print("Carregando: $url");
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
            print("Página carregada: $url");
          },
          onNavigationRequest: (request) => NavigationDecision.navigate,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SummerClass")),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
