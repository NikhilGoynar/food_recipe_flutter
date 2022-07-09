import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {
  late String url;
  RecipeView({required this.url});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  late String Rurl;
  Completer<WebViewController> controller = Completer<WebViewController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.url.toString().contains("http://")) {
      Rurl = widget.url.toString().replaceAll("http", "https");
    } else {
      Rurl = widget.url;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Webview"),
      ),
      body: SafeArea(
          child: Container(
        child: WebView(
          initialUrl: Rurl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            setState(() {
              controller.complete(webViewController);
            });
          },
        ),
      )),
    );
  }
}
