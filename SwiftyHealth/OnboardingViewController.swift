import UIKit
import CMHealth

class OnboardingViewController: UIViewController, ORKTaskViewControllerDelegate, CMHAuthViewDelegate {

    // MARK: Properties
    private var consentResult: ORKTaskResult? = nil
    private var consentDoc: ORKConsentDocument? = nil

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Target-Action

    @IBAction func consentButtonDidPress(sender: UIButton) {
        let (task, doc) = Tasks.consentAndDoc
        consentDoc = doc

        let consentVC = ORKTaskViewController(task: task, taskRunUUID: nil)
        consentVC.delegate = self

        presentViewController(consentVC, animated:true, completion:nil)
    }

    @IBAction func signinButtonDidPress(sender: UIButton) {
        let signinVC = CMHAuthViewController.loginViewController()
        signinVC.delegate = self

        presentViewController(signinVC, animated: true, completion: nil)
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
            handleConsentCompletion(taskViewController.result)
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

    private func handleConsentCompletion(result: ORKTaskResult) {
        consentResult = result

        let signupVC = CMHAuthViewController.signupViewController()
        signupVC.delegate = self

        presentViewController(signupVC, animated: true, completion: nil)
    }

    private func signup(email email: String, password: String) {
        CMHUser.currentUser().signUpWithEmail(email, password: password) { signupError in
            if let signupError = signupError {
                print("Error during signup: \(signupError.localizedDescription)")
                return
            }

            CMHUser.currentUser().uploadUserConsent(self.consentResult){ (consent, uploadError) in
                if let uploadError = uploadError {
                    print("Error uploading consent: \(uploadError.localizedDescription)")
                    return
                }

                dispatch_async(dispatch_get_main_queue()) {
                    self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                }

                guard let consentDoc = self.consentDoc,
                    signatureResult = self.consentResult?.signatureResult() else {
                    return
                }

                signatureResult.applyToDocument(consentDoc)

                consentDoc.makePDFWithCompletionHandler{ (pdfData, error) in
                    guard let pdfData = pdfData else {
                        var message = "Unknown error creating PDF"
                        if let error = error {
                            message = "Error creating PDF: \(error.localizedDescription)"
                        }

                        print(message)
                        return
                    }

                    consent?.uploadConsentPDF(pdfData) { error in
                        if let error = error {
                            print("Error uploading pdf: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
    }

    private func login(email email: String, password: String) {
        CMHUser.currentUser().loginWithEmail(email, password: password) { error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                return
            }

            dispatch_async(dispatch_get_main_queue()) {
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}
