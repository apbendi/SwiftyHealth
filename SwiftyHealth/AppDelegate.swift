import UIKit
import CMHealth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        CMHealth.setAppIdentifier(Secrets.AppId, appSecret: Secrets.AppSecret)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {

    }

    func applicationDidEnterBackground(application: UIApplication) {

    }

    func applicationWillEnterForeground(application: UIApplication) {

    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {

    }
}

extension String {
    func message(forError error: NSError?) -> String {
        if let error = error {
            return "Error \(self): \(error.localizedDescription)"
        } else {
            return "Unknown error \(self)"
        }
    }
}

