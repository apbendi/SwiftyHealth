import UIKit

class ShowPDFViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var pdfData: NSData? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let pdfData = pdfData else {
            return
        }

        if let baseURL = NSURL(string: "http://google.com") {
            webView?.loadData(pdfData, MIMEType: "application/pdf", textEncodingName: "utf-8", baseURL: baseURL)
        }
    }

    @IBAction func doneButtonDidPress(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
