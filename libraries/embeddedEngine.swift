import SwiftUI
import WebKit
import SafariServices

// Coordinator handles delegate and JS messages
class WebViewCoordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Page loaded")
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("JS says: \(message.body)")
    }
}

// Simple WKWebView wrapper for SwiftUI
struct WebView: UIViewRepresentable {
    let url: URL

    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "jsHandler")

        // Inject JS that sends a message back to Swift
        let js = "window.webkit.messageHandlers.jsHandler.postMessage('Hello from JS!');"
        let userScript = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(userScript)

        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

// Simple Safari View for external browser
struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

// SwiftUI example using both
struct ContentView: View {
    @State private var showSafari = false
    let url = URL(string: "https://apple.com")!

    var body: some View {
        VStack {
            WebView(url: url)
                .frame(height: 300)

            Button("Open in Safari") {
                showSafari = true
            }
            .sheet(isPresented: $showSafari) {
                SafariView(url: url)
            }
        }
    }
}
