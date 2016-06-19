import UIKit

/**
    Daily forecast thumbnail used in carousel.
*/
class WPForecastThumbnailController: UIViewController {
	@IBOutlet var labelWeekday:		UILabel!
	@IBOutlet var labelTemperature:	UILabel!
	@IBOutlet var labelCondition:	UILabel!
	@IBOutlet var labelPeriod:		UILabel!
	@IBOutlet var labelPop:			UILabel!
	@IBOutlet var imageIcon:	UIImageView!
	var forecast: WPForecastdayModel!

	override func viewDidLoad() {
		super.viewDidLoad()
		view.enable_border(width:2, color:WP.color.thumbnailBorder, radius: 10)
	}
	func reload() {
		super.viewDidLoad()
		if let weekday = forecast.date?.weekday {
			labelWeekday.text = weekday
		} else {
			labelWeekday.text = WP.s.unknown
		}
		if let low = forecast.low?.str, let high = forecast.high?.str {
			labelTemperature.text = String(format: "%@ - %@", low, high)
		} else {
			labelTemperature.text = WP.s.unknown
		}
		if let conditions = forecast.conditions {
			labelCondition.text = conditions
		} else {
			labelCondition.text = WP.s.unknown
		}
		labelPeriod.text = WP.periodToString(forecast.period)
		labelPop.text = forecast.popPercentage
		imageIcon.image_load(forecast.icon_url, clear:true)
	}
}