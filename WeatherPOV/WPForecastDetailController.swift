import UIKit
import LFramework

/**
	Forecast detail. It contains a static table view so most works are done in `Main.storyboard`.
*/
class WPForecastDetailController: UITableViewController {
	@IBOutlet var cellDate:	UITableViewCell!

	@IBOutlet var cellHigh: 		UITableViewCell!
	@IBOutlet var cellLow:			UITableViewCell!
	@IBOutlet var cellConditions:	UITableViewCell!
	@IBOutlet var cellPop:			UITableViewCell!
	@IBOutlet var cellHumidity:		UITableViewCell!

	@IBOutlet var cellWindMaxSpeed:			UITableViewCell!
	@IBOutlet var cellWindMaxDirection:		UITableViewCell!
	@IBOutlet var cellWindMaxDegrees:		UITableViewCell!
	@IBOutlet var cellWindAverageSpeed:		UITableViewCell!
	@IBOutlet var cellWindAverageDirection:	UITableViewCell!
	@IBOutlet var cellWindAverageDegrees:	UITableViewCell!

	@IBOutlet var cellRainDay:		UITableViewCell!
	@IBOutlet var cellRainNight:	UITableViewCell!
	@IBOutlet var cellRainAll:		UITableViewCell!

	@IBOutlet var cellSnowDay:		UITableViewCell!
	@IBOutlet var cellSnowNight:	UITableViewCell!
	@IBOutlet var cellSnowAll:		UITableViewCell!

	var forecast: WPForecastdayModel!

	override func viewDidLoad() {
		super.viewDidLoad()
		//	date
		if let date = forecast.date?.pretty {
			cellDate.detailTextLabel?.text = date
		}
		//	weather
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
		cellPop.textLabel?.text = forecast.popPercentage
		//	wind
		if let speed = forecast.maxwind?.speed {
			cellWindMaxSpeed.detailTextLabel?.text = speed
		}
		if let speed = forecast.avewind?.speed {
			cellWindAverageSpeed.detailTextLabel?.text = speed
		}
		if let direction = forecast.maxwind?.dir {
			cellWindMaxDirection.detailTextLabel?.text = direction
		}
		if let direction = forecast.avewind?.dir {
			cellWindAverageDirection.detailTextLabel?.text = direction
		}
		if let degree = forecast.maxwind?.degrees {
			cellWindMaxDegrees.detailTextLabel?.text = String(format: "%.0f %@", degree, WP.s.degree)
		}
		if let degree = forecast.avewind?.degrees {
			cellWindAverageDegrees.detailTextLabel?.text = String(format: "%.0f %@", degree, WP.s.degree)
		}
		//	rain
		if let str = forecast.qpf_day?.str {
			cellRainDay.detailTextLabel?.text = str
		}
		if let str = forecast.qpf_night?.str {
			cellRainNight.detailTextLabel?.text = str
		}
		if let str = forecast.qpf_allday?.str {
			cellRainAll.detailTextLabel?.text = str
		}
		//	snow
		if let str = forecast.snow_day?.str {
			cellSnowDay.detailTextLabel?.text = str
		}
		if let str = forecast.snow_night?.str {
			cellSnowNight.detailTextLabel?.text = str
		}
		if let str = forecast.snow_allday?.str {
			cellSnowAll.detailTextLabel?.text = str
		}
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