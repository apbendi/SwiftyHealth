import UIKit
import CMHealth

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        guard CMHUser.currentUser().isLoggedIn else {
            self.performSegueWithIdentifier("Onboarding", sender: self)
            return
        }
    }
}

