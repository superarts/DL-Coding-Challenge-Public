//	WP: Project WeatherPOV
struct WP {
	static let storyboard_main = UIStoryboard(name: "Main", bundle: nil)
	static let storyboard = storyboard_main

	//	const
	struct api {
		static let key = "dc60d98175ba0199"
		static let root = "https://api.wunderground.com/api/" + key + "/"
		static let geolookup = "geolookup/q/"
		static let forecast = "forecast/q/"
	}
	struct key {
		static let temperatureUnit = "temp-unit"
	}

	//	utility
	static func periodToString(period: Int) -> String {
		if period == 1 {
			return "Today"
		} else if period == 2 {
			return "Tomorrow"
		}
		return String(format: "%zi days later", period - 1)
	}
	static func isFahrenheit() -> Bool {
		return NSUserDefaults.integer(WP.key.temperatureUnit) == 0
	}
	static func isCelsius() -> Bool {
		return NSUserDefaults.integer(WP.key.temperatureUnit) == 1
	}
	static var isF: Bool {
		return isFahrenheit()
	}
	static var isC: Bool {
		return isCelsius()
	}
}

class WPView: UIView {
    @IBOutlet var parentViewController: UIViewController?
}