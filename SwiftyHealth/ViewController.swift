import UIKit
import CMHealth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let _ = CMStore.defaultStore()?.user else {
            return;
        }

        let data = DataBag()
        data.stringData = "Hello World"

        data.saveWithUser(CMUser.currentUser()) { response in
            if let error = response?.error {
                print("Error uploading data: \(error.localizedDescription)")
            }

            data.stringData = "Goodbye World"
            print("Upload Successful")

            data.saveWithUser(CMUser.currentUser()) { response in
                if let error = response?.error {
                    print("Error updating data: \(error.localizedDescription)")
                }

                print("Update Successful")
            }
        }
    }
}

