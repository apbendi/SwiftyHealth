import UIKit
import CMHealth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let data = DataBag()
        data.stringData = "Hello World"

        data.saveWithUser(CMUser.currentUser()) { response in
            if let error = response?.error {
                print("Error uploading data: \(error.localizedDescription)")
            }

            print("Upload Successful")
        }
    }
}

