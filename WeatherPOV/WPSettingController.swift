import UIKit

class WPSettingController: UITableViewController {
	@IBOutlet var segmentUnit: UISegmentedControl!
	@IBOutlet var cellVersion: UITableViewCell!

	override func viewDidLoad() {
		super.viewDidLoad()
		if let unit = NSUserDefaults.integer(WP.key.temperatureUnit) {
			segmentUnit.selectedSegmentIndex = unit
		}
		if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String,
			let build = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String {
			cellVersion.detailTextLabel?.text = version + "." + build
		}
	}
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		//UIApplication.sharedApplication().statusBarStyle = .Default
	}

	@IBAction func actionUnitChanged(segment: UISegmentedControl) {
		NSUserDefaults.integer(WP.key.temperatureUnit, segment.selectedSegmentIndex)
	}
    override func lf_actionDismiss() {
		super.lf_actionDismiss()
		UIApplication.sharedApplication().statusBarStyle = .LightContent
	}
}
