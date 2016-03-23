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
        guard nil == error else {
            print( "during consent".message(forError: error) )
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
            guard nil == signupError else {
                print( "signing up".message(forError: signupError) )
                return
            }

            CMHUser.currentUser().uploadUserConsent(self.consentResult){ (consent, uploadError) in
                guard nil == uploadError else {
                    print( "uploading consent".message(forError: uploadError) )
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
                        print( "creating conent PDF".message(forError: error) )
                        return
                    }

                    consent?.uploadConsentPDF(pdfData) { error in
                        if let error = error {
                            print( "uploading consent PDF".message(forError: error) )
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
