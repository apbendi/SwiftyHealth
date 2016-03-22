import UIKit
import CMHealth

class OnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func consentButtonDidPress(sender: UIButton) {
        let consentVC = ORKTaskViewController(task: ConsentBuilder.consentTask(), taskRunUUID: nil)

        self.presentViewController(consentVC, animated:true, completion:nil)
    }
}
