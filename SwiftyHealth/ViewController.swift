import UIKit
import CMHealth

class ViewController: UIViewController, ORKTaskViewControllerDelegate {
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
        surveyVC.delegate = self

        presentViewController(surveyVC, animated: true, completion: nil)
    }
    
    @IBAction func tapButtonDidPress(sender: UIButton) {
        let tapVC = ORKTaskViewController(task: Tasks.tap, taskRunUUID: nil)
        tapVC.delegate = self

        presentViewController(tapVC, animated: true, completion: nil)
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

    // MARK: ORKTaskViewDelegate

    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)

        switch reason {
        case .Completed:
            upload(taskResult: taskViewController.result)
        default:
            break
        }
    }

    // MARK: Private Helpers

    private func upload(taskResult result: ORKTaskResult) {
        if result.identifier == "SwiftyHealthTappingTask" {
            ORKTappingSample
            print(result)
            return
        }

        result.cmh_saveWithCompletion { (status, error) in
            if let error = error {
                print("Error saving results: \(error.localizedDescription)")
                return
            }

            print("Result: \(status)")
        }
    }
}

