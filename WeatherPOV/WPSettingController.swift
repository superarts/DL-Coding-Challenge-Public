import UIKit

class WPSettingController: UITableViewController {
	@IBOutlet var segmentUnit: UISegmentedControl!

	override func viewDidLoad() {
		super.viewDidLoad()
		if let unit = NSUserDefaults.integer(WP.key.temperatureUnit) {
			segmentUnit.selectedSegmentIndex = unit
		}
	}
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		UIApplication.sharedApplication().statusBarStyle = .Default
	}

	@IBAction func actionUnitChanged(segment: UISegmentedControl) {
		NSUserDefaults.integer(WP.key.temperatureUnit, segment.selectedSegmentIndex)
	}
    override func lf_actionDismiss() {
		super.lf_actionDismiss()
		UIApplication.sharedApplication().statusBarStyle = .LightContent
	}
}

class WPForecastDetailController: UITableViewController {
	@IBOutlet var cellDate: UITableViewCell!
	@IBOutlet var cellHigh: UITableViewCell!
	@IBOutlet var cellLow: UITableViewCell!
	@IBOutlet var cellConditions: UITableViewCell!
	@IBOutlet var cellPop: UITableViewCell!
	@IBOutlet var cellHumidity: UITableViewCell!
	var forecast: WPForecastdayModel!

	override func viewDidLoad() {
		super.viewDidLoad()
		if let date = forecast.date?.pretty {
			cellDate.detailTextLabel?.text = date
		}
		if let high = forecast.high?.str {
			cellHigh.detailTextLabel?.text = high
		}
		if let low = forecast.low?.str {
			cellLow.detailTextLabel?.text = low
		}
		if let conditions = forecast.conditions {
			cellConditions.detailTextLabel?.text = conditions
		}
		cellHumidity.detailTextLabel?.text = String(format: "%.0f%%", forecast.avehumidity)
		cellPop.imageView?.image_load(forecast.icon_url, clear:true)
		cellPop.textLabel?.text = String(format: "%zi%%", forecast.pop)
	}
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		UIApplication.sharedApplication().statusBarStyle = .Default
	}
    override func lf_actionPop() {
		super.lf_actionPop()
		UIApplication.sharedApplication().statusBarStyle = .LightContent
	}
}