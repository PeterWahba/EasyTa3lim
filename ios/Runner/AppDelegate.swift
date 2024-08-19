import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {

    var overlayController = UIViewController()

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        //Add observer to detect screen recording
        NotificationCenter.default.addObserver(self, selector: #selector(screenRecordingStatusChanged), name: UIScreen.capturedDidChangeNotification, object: nil)

        //Add observer to detect screenshot taken
        NotificationCenter.default.addObserver(self, selector: #selector(screenshotHasTaken), name: UIApplication.userDidTakeScreenshotNotification, object: nil)


        //To check if the app was already launched by keep recording turned ON
        //Currently 1.0 is the time assumed for the app to get launched. One can change it as per the requirement here.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if UIScreen.main.isCaptured { //Screen recording is ON
                self.displayOverlayControllerWith(message: "Screen recording is not allowed while using the app. Kindly turn off the screen recording to continue using the app.")
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func applicationWillResignActive(
        _ application: UIApplication
      ) {
        self.window.isHidden = true;
      }
      override func applicationDidBecomeActive(
        _ application: UIApplication
      ) {
        self.window.isHidden = false;
      }

    @objc func screenRecordingStatusChanged() {
        if UIScreen.main.isCaptured { //Screen recording is ON
            self.displayOverlayControllerWith(message: "Screen recording is not allowed while using the app. Kindly turn off the screen recording to continue using the app.")
        } else { //Screen recording turned OFF
            self.overlayController.dismiss(animated: false, completion: nil)
        }
    }

    @objc func screenshotHasTaken() {
        self.displayOverlayControllerWith(message: "Screenshots are not allowed in our app. Your account can get banned!\n\nKindly relaunch  the app again to continue using the app.")
    }

    fileprivate func displayOverlayControllerWith(message : String) {
        if UIApplication.shared.windows.count > 0 {
            let rootWindow = UIApplication.shared.windows[0]

            self.overlayController.view.backgroundColor = .white
            self.overlayController.modalPresentationStyle = .fullScreen

            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height - (rootWindow.safeAreaInsets.top + rootWindow.safeAreaInsets.bottom)
            let frameOfLabel = CGRect.init(x: 20, y: screenHeight/2 - 100, width: screenWidth - 40, height: 200)

            if let labelMessage = self.overlayController.view.viewWithTag(1010) as? UILabel {
                labelMessage.text = message
            } else {
                let labelMessage = UILabel.init(frame: frameOfLabel)
                labelMessage.tag = 1010
                labelMessage.numberOfLines = 0
                labelMessage.font = UIFont.systemFont(ofSize: 18, weight: .regular)
                labelMessage.text = message
                labelMessage.textColor = .black
                labelMessage.textAlignment = .center
                self.overlayController.view.addSubview(labelMessage)
            }

            rootWindow.rootViewController?.present(self.overlayController, animated: false, completion: nil)
        }
    }
}
