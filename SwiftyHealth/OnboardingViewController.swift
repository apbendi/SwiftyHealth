import UIKit
import CMHealth

class OnboardingViewController: UIViewController, ORKTaskViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func consentButtonDidPress(sender: UIButton) {
        let consentVC = ORKTaskViewController(task: ConsentBuilder.consentTask(), taskRunUUID: nil)
        consentVC.delegate = self

        presentViewController(consentVC, animated:true, completion:nil)
    }

    // MARK: ORKTaskViewControllerDelegate

    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        if let error = error {
            print("Consent Error: \(error.localizedDescription)")
            return
        }

        dismissViewControllerAnimated(true, completion: nil)

        switch reason {
        case .Completed:
            handleConsentCompletion()
        default:
            print("Consent Dismissed")
        }
    }

    // MARK: Private helpers

    private func handleConsentCompletion() {
        print("Handle Consent")
    }
}
