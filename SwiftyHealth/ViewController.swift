import UIKit
import CMHealth

class ViewController: UIViewController, ORKTaskViewControllerDelegate {

    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signatureImage: UIImageView!
    @IBOutlet weak var surveyCountLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: Lifecycle

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        guard CMHUser.currentUser().isLoggedIn else {
            performSegueWithIdentifier("Onboarding", sender: self)
            return
        }

        CMHUser.currentUser().addObserver(self, forKeyPath: "userData", options: NSKeyValueObservingOptions.Initial.union(NSKeyValueObservingOptions.New), context: nil)

        if nil == signatureImage.image {
            fetchSignature()
        }

        fetchSurveys()
    }

    deinit {
        CMHUser.currentUser().removeObserver(self, forKeyPath: "userData")
    }

    // MARK: KVO

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let user = object as? CMHUser,
            let data = user.userData else {
                return
        }

        emailLabel.text = data.email

        if let given = data.givenName,
            let family = data.familyName {
            nameLabel.text = "\(given) \(family)"
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
            guard nil == error else {
                print( "logging out".message(forError: error) )
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
            print(result)
            return
        }

        result.cmh_saveWithCompletion { (status, error) in
            guard nil == error else {
                print( "saving results".message(forError: error) )
                return
            }

            print("Result: \(status)")
            self.fetchSurveys()
        }
    }

    private func fetchSurveys() {
        ORKTaskResult.cmh_fetchUserResultsForStudyWithIdentifier("SwiftyHealthSurveyTask") { (results, error) in
            guard let results = results else {
                print( "fetching surveys".message(forError: error) )
                return
            }

            dispatch_async(dispatch_get_main_queue()) {
                self.surveyCountLabel.text = String(results.count)
            }
        }
    }

    private func fetchSignature() {
        CMHUser.currentUser().fetchUserConsentForStudyWithCompletion { (consent, error) in
            guard let consent = consent else {
                print( "fetching consent".message(forError: error) )
                return
            }

            consent.fetchSignatureImageWithCompletion({ (image, error) in
                guard let image = image else {
                    print( "fetching signature".message(forError: error) )
                    return
                }

                dispatch_async(dispatch_get_main_queue()) {
                    self.signatureImage.image = image
                }
            })
        }
    }
}

