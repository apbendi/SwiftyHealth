import UIKit
import CMHealth

class OnboardingViewController: UIViewController, ORKTaskViewControllerDelegate, CMHAuthViewDelegate {

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

    // MARK: CMHAuthViewDelegate
    func authViewCancelledType(authType: CMHAuthType) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func authViewOfType(authType: CMHAuthType, didSubmitWithEmail email: String, andPassword password: String) {
        dismissViewControllerAnimated(true, completion: nil)

        switch authType {
        case .Signup:
            signup(email: email, password: password)
        case .Login:
            login(email: email, password: password)
        }
    }

    // MARK: Private helpers

    private func handleConsentCompletion() {
        let signupVC = CMHAuthViewController.signupViewController()
        signupVC.delegate = self

        presentViewController(signupVC, animated: true, completion: nil)
    }

    private func signup(email email: NSString, password: NSString) {
        print("Signup \(email) \(password)")
    }

    private func login(email email: NSString, password: NSString) {
        print("Login \(email) \(password)")
    }
}
