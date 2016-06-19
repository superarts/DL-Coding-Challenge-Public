//	WP: Project WeatherPOV
struct WP {
	//	variables
	static var station:		WPStationModel?
	static var forecast:	WPForecastdayModel?
	static var country:	String?
	static var city:	String?
	static var user:	PFUser?

	//	consts
	static let storyboard_main = UIStoryboard(name: "Main", bundle: nil)
	static let storyboard = storyboard_main
	struct api {
		static let key = "dc60d98175ba0199"
		static let root = "https://api.wunderground.com/api/" + key + "/"
		static let geolookup = "geolookup/q/"
		static let forecast = "forecast10day/q/"
		static let formatRadar = "%@animatedradar/animatedsatellite/q/%@/%@.gif?num=6&delay=50&interval=30"
		static let astronomy = "astronomy/q/"
		static var radar: String? {
			if let country = WP.country, let city = WP.city {
				return String(format: formatRadar, root, country, city)
			}
			return nil
		}
	}
	struct key {
		static let unitTemperature		= "unit-temperature"
		static let unitShortDistance	= "unit-short-distance"
		static let unitLongDistance		= "unit-long-distance"
	}
	//	text copies
	struct s {
		static let confirm = "Confirm"
		static let cancel = "Cancel"
		static let loading = "Loading"
		static let submitting = "Submitting"
		static let submit_failed = "Submission failed: "
		static let reloading = "Reloading"
		static let signing_in = "Logging in"
		static let signing_up = "Registering"
		static let signin_successful = "Login successful"
		static let signup_successful = "Register successful"
		static let signin_failed = "Login failed: "
		static let signup_failed = "Register failed: "
		static let invalid_email = "Please enter a valid email address"
		static let password_too_short = "Password is too short"
		static let username_too_short = "Username is too short"
		static let username_too_long = "Username is too long"
		static let unknown = "Unknown"
		static let degree = "º"
		static let location_failed = "Failed to update your current location: "
	}
	struct color {
		static let tableInterlace	= UIColor(rgb: 0xf0f8ff)
		static let thumbnailBorder	= UIColor(rgb: 0xaaddff)
	}

	//	utilities
	static func periodToString(period: Int) -> String {
		if period == 1 {
			return "Today"
		} else if period == 2 {
			return "Tomorrow"
		}
		return String(format: "%zi days later", period - 1)
	}
	//	temperature
	static func isFahrenheit() -> Bool {
		return NSUserDefaults.integer(WP.key.unitTemperature) == 0
	}
	static func isCelsius() -> Bool {
		return NSUserDefaults.integer(WP.key.unitTemperature) == 1
	}
	static var isF: Bool {
		return isFahrenheit()
	}
	static var isC: Bool {
		return isCelsius()
	}
	//	short distance
	static func isShortDistanceInch() -> Bool {
		return NSUserDefaults.integer(WP.key.unitShortDistance) == 0
	}
	static func isShortDistanceCM() -> Bool {
		return NSUserDefaults.integer(WP.key.unitShortDistance) == 1
	}
	static var isInch: Bool {
		return isShortDistanceInch()
	}
	static var isCM: Bool {
		return isShortDistanceCM()
	}
	//	long distance
	static func isLongDistanceMile() -> Bool {
		return NSUserDefaults.integer(WP.key.unitLongDistance) == 0
	}
	static func isLongDistanceKM() -> Bool {
		return NSUserDefaults.integer(WP.key.unitLongDistance) == 1
	}
	static var isMile: Bool {
		return isLongDistanceMile()
	}
	static var isKM: Bool {
		return isLongDistanceKM()
	}
	//	display and hide a text message
    static func show(text:String) {
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window {
            MBProgressHUD.show(text, view:window)
        }
    }
    static func hide() {
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window {
            MBProgressHUD.hideAllHUDsForView(window, animated:true)
        }
    }
	//	display an error for 2 seconds
    static func showError(error:NSError?, text: String? = nil) {
		hide()
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window, let error = error {
            var message = error.localizedDescription
            if text != nil {
                message = text! + message
            }
            MBProgressHUD.show(message, view:window, duration:2)
        }
    }
	//	display a text message for 2 seconds
    static func showText(text:String) {
		hide()
        if let app = UIApplication.sharedApplication().delegate as? AppDelegate, let window = app.window {
            MBProgressHUD.show(text, view:window, duration:2)
        }
    }
}

//	In WPForecastThumbnailController, we need to get a UIViewController from a
//	UIView since iCarousel only works with UIViews.
class WPView: UIView {
    @IBOutlet var parentViewController: UIViewController?
}

//	helper
extension MBProgressHUD {
	class func show(title: String, view: UIView, duration: Float? = nil) -> MBProgressHUD {
		let hud = MBProgressHUD.showHUDAddedTo(view, animated: true) 
		hud.detailsLabelFont = UIFont.systemFontOfSize(18)
		hud.detailsLabelText = title
		if duration != nil {
			hud.mode = MBProgressHUDMode.Text
			hud.minShowTime = duration!
			hud.graceTime = duration!
			MBProgressHUD.hideAllHUDsForView(view, animated:true)
		}
        return hud
	}
}