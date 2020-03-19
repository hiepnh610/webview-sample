//
//  ViewController.swift
//  webview
//
//  Created by Hiep Nguyen on 3/13/20.
//  Copyright © 2020 Hiep Nguyen. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class ViewController: UIViewController {
    
    let wkUserContentController = WKUserContentController()

    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let userScript = WKUserScript.scaleToFitScript()
        wkUserContentController.addUserScript(userScript)
        config.userContentController = wkUserContentController
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.allowsBackForwardNavigationGestures = false
        webView.scrollView.bounces = false
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        registerListenerWebView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resignListenerWebView()
    }

    func configureView() {
        view.addSubview(webView)
        webView.frame = view.bounds
        
        
        guard let url = URL(string: "http://localhost:8080/") else { return }
        let urlRequest = URLRequest(url: url)
        self.webView.load(urlRequest)

    }
}

extension ViewController {

    func registerListenerWebView() {
        webView.navigationDelegate = self
        // declare function to listener from webview
        wkUserContentController.add(self, name: "sampleFunction")
    }

    func resignListenerWebView() {
        webView.stopLoading()
        // remove function listened from webview
        wkUserContentController.removeScriptMessageHandler(forName: "sampleFunction")
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // listener webview call js function sampleFunction -> json/String
        
        //ex: function sampleFunction(json)
        
        if message.name == "sampleFunction", let dataString = message.body as? String { //samplefunction
//            let json = registedFunction.data(using: .utf8) // convert data to  json model
            // model: let dg = Dialog(title: String, messsge: String)
            // showOSDialog(dg.title, dg.messsge)
            showOSDialog(title: "Dialog", message: dataString)
        }
        
        
    }
    
}
extension ViewController: WKNavigationDelegate {
    func webView(_: WKWebView, didCommit _: WKNavigation) {
//        webview start loading
    }

    func webView(_: WKWebView, didFinish _: WKNavigation) {
//        webview loading finish

    }

    // swiftlint:disable implicitly_unwrapped_optional
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        guard let urlError = error as? URLError else { return }
        if urlError.code == URLError.notConnectedToInternet ||
            urlError.code == URLError.badServerResponse ||
            urlError.code == URLError.timedOut {
        }
        //catch error from webview
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
//        listener?.webViewServiceErrors.accept(.network)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        SnackBar.show(error: error.localizedDescription)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        loadingTimeOut.accept(())
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            guard let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }
            if url.absoluteString.hasPrefix("one://vinid.net") || url.absoluteString.hasPrefix("tel:") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                decisionHandler(.cancel)
            } else {
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
                decisionHandler(.cancel)
            }
        } else {
            decisionHandler(.allow)
        }
    }
}

extension ViewController {
    func showOSDialog(title: String?, message: String?) {
        let actionSheet = UIAlertController(title: "Welcome", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            // do something
            
            guard let message = message else { return }
            let javascript = "window.webview.listenerFromNative('\(message)')"
            print("message \(message)")
            self?.webView.evaluateJavaScript(javascript, completionHandler: nil)
        })

        actionSheet.addAction(cancelAction)
        actionSheet.addAction(okAction)

        present(actionSheet, animated: true, completion: nil)
    }
}

extension WKUserScript {
    public class func scaleToFitScript() -> WKUserScript {
        
        // swiftlint:disable line_length
        let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1, maximum-scale=1'); document.getElementsByTagName('head')[0].appendChild(meta);"
        // swiftlint:enable line_length

        let userScript = WKUserScript(source: jscript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        return userScript
    }
}

