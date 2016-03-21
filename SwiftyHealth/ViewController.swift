import UIKit
import CMHealth

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        guard CMHUser.currentUser().isLoggedIn else {
            let consentVC = ORKTaskViewController(task: ConsentBuilder.consentTask(), taskRunUUID: nil)
            self.presentViewController(consentVC, animated: true, completion: nil)
            return
        }
    }
}

