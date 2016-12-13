import UIKit
import SAKit

/**
    Mainly about unit settings. Stored in user defaults.
	Version string is automatically updated in a build phase script.
*/
class WPSettingController: UITableViewController {
	@IBOutlet var segmentUnit:			UISegmentedControl!
	@IBOutlet var segmentTemperature:	UISegmentedControl!
	@IBOutlet var segmentShortDistance:	UISegmentedControl!
	@IBOutlet var segmentLongDistance:	UISegmentedControl!
	@IBOutlet var cellVersion: UITableViewCell!

	override func viewDidLoad() {
		super.viewDidLoad()
		if let unit = UserDefaults.integer(WP.key.unitTemperature) {
			segmentTemperature.selectedSegmentIndex = unit
		}
		if let unit = UserDefaults.integer(WP.key.unitShortDistance) {
			segmentShortDistance.selectedSegmentIndex = unit
		}
		if let unit = UserDefaults.integer(WP.key.unitLongDistance) {
			segmentLongDistance.selectedSegmentIndex = unit
		}
		reloadUnitSystem()
		if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
			let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
			cellVersion.detailTextLabel?.text = version + "." + build
		}
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		//UIApplication.sharedApplication().statusBarStyle = .Default
	}

	func reloadUnitSystem() {
		if segmentTemperature.selectedSegmentIndex		== 0 &&
			segmentShortDistance.selectedSegmentIndex	== 0 &&
			segmentLongDistance.selectedSegmentIndex	== 0 {
			segmentUnit.selectedSegmentIndex = 0
		} else if segmentTemperature.selectedSegmentIndex	== 1 &&
			segmentShortDistance.selectedSegmentIndex		== 1 &&
			segmentLongDistance.selectedSegmentIndex		== 1 {
			segmentUnit.selectedSegmentIndex = 1
		} else {
			segmentUnit.selectedSegmentIndex = -1
		}
	}

	@IBAction func actionUnitChanged(_ segment: UISegmentedControl) {
		if segment == segmentTemperature {
			UserDefaults.integer(WP.key.unitTemperature, segment.selectedSegmentIndex)
		} else if segment == segmentShortDistance {
			UserDefaults.integer(WP.key.unitShortDistance, segment.selectedSegmentIndex)
		} else if segment == segmentLongDistance {
			UserDefaults.integer(WP.key.unitLongDistance, segment.selectedSegmentIndex)
		} else if segment == segmentUnit {
			segmentTemperature.selectedSegmentIndex		= segment.selectedSegmentIndex
			segmentShortDistance.selectedSegmentIndex	= segment.selectedSegmentIndex
			segmentLongDistance.selectedSegmentIndex	= segment.selectedSegmentIndex
			UserDefaults.integer(WP.key.unitTemperature, segment.selectedSegmentIndex)
			UserDefaults.integer(WP.key.unitShortDistance, segment.selectedSegmentIndex)
			UserDefaults.integer(WP.key.unitLongDistance, segment.selectedSegmentIndex)
		}
		reloadUnitSystem()
	}
    @IBAction func lf_actionDismiss() {
		super.sakitActionDismiss()
		UIApplication.shared.statusBarStyle = .lightContent
	}
}
