import UIKit
import CMHealth

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        guard CMHUser.currentUser().isLoggedIn else {
            performSegueWithIdentifier("Onboarding", sender: self)
            return
        }
    }

    // MARK: Target-Action


    @IBAction func surveyButtonDidPress(sender: UIButton) {
        let surveyVC = ORKTaskViewController(task: Tasks.survey, taskRunUUID: nil)

        presentViewController(surveyVC, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonDidPress(sender: UIButton) {
        CMHUser.currentUser().logoutWithCompletion { error in
            if let error = error {
                print("Error Logging Out: \(error.localizedDescription)")
                return
            }

            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("Onboarding", sender: self)
            }
        }
    }
}

