import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mailto/mailto.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class TheBusiness extends StatefulWidget {
  static const id = 'thebusiness';
  @override
  _TheBusinessState createState() => _TheBusinessState();
}

class _TheBusinessState extends State<TheBusiness> {
  final String link = "https://thebusinesspassport.com/";
  InAppWebViewController webView;
  ContextMenu contextMenu;
  String url = "";

  double progress = 0;
  bool pdf = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: Scaffold(
            body: Container(
                child: Column(children: <Widget>[
          Container(
              child: progress < 1.0
                  ? LinearProgressIndicator(value: progress)
                  : Container()),
          Expanded(
            child: pdf
                ? Container(
                    child: InAppWebView(
                      initialUrl: "https://thebusinesspassport.com/",
                      contextMenu: contextMenu,
                      initialHeaders: {},
                      initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                        clearCache: true,
                        javaScriptEnabled: true,
                        javaScriptCanOpenWindowsAutomatically: true,
                      )),
                      onWebViewCreated: (InAppWebViewController controller) {
                        setState(() {
                          webView = controller;
                        });
                      },
                      onLoadStart:
                          (InAppWebViewController controller, String url) {
                        setState(() {
                          this.url = url;
                        });
                      },
                      onLoadError: (InAppWebViewController controller,
                          String url, int number, String error) {
                        if (url ==
                            "mailto:info@thebusinesspassport.com?subject=feedback") {
                          setState(() async {
                            final url = Mailto(
                              to: [
                                'info@thebusinesspassport.com',
                              ],
                              cc: [
                                'info@thebusinesspassport.com',
                              ],
                              bcc: [
                                'info@thebusinesspassport.com',
                              ],
                              subject: 'Welcome to The Business Passport',
                              body: 'Type here.....',
                            ).toString();
                            if (await canLaunch(url) != null) {
                              await launch(url);
                            } else {
                              showCupertinoDialog(
                                context: context,
                                builder: CupertinoAlertDialog(
                                  title: Text("please try later"),
                                  content: Text('Again try!'),
                                ).build,
                              );
                            }
                          });
                        }
                      },
                      onLoadStop: (InAppWebViewController controller,
                          String url) async {
                        setState(() {
                          this.url = url;
                        });
                      },
                      onDownloadStart:
                          (InAppWebViewController controller, String url) {
                        setState(() {
                          pdf = false;
                        });
                      },
                      onProgressChanged:
                          (InAppWebViewController controller, int progress) {
                        setState(() {
                          this.progress = progress / 100;
                        });
                      },
                    ),
                  )
                : SfPdfViewer.network(url),
          ),
        ]))),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    if (pdf == false) {
      setState(() {
        pdf = true;
      });
    } else if (webView != null && url != link) {
      setState(() {
        webView.goBack();
      });
    } else if (link == url) {
      return true;
    } else {
      return false;
    }
    return false;
  }
}
