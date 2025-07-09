import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymongoWebView extends StatelessWidget {
  final String checkoutUrl;

  const PaymongoWebView({super.key, required this.checkoutUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Paymongo Payment")),
      body: WebViewWidget(
        controller:
            WebViewController()
              ..loadRequest(Uri.parse(checkoutUrl))
              ..setJavaScriptMode(JavaScriptMode.unrestricted),
      ),
    );
  }
}
