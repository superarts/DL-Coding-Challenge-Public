import UIKit
import MapKit

class WPForecastController: LFTableController, CLLocationManagerDelegate {
	@IBOutlet var labelCity: UILabel!
	var locationManager: CLLocationManager!

	override func viewDidLoad() {
		super.viewDidLoad()
		tabBarController?.tabBar.hidden = true
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		//	reload UI whenever view is loaded
		table.alpha = 0
		startLocationManager()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func startLocationManager() {
		locationManager = CLLocationManager()
		locationManager.delegate = self
		//	weather service does not require the best accuracy
		locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
	}

	func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
		for location in locations {
			LF.log("LOCATION", location)
			loadWeather(location)
			self.locationManager.stopUpdatingLocation()
			break
		}
	}

	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("LOCATION error: \(error)")
	}

	func loadWeather(location: CLLocation) {
		WPClients.geolookup(location.coordinate) {
			(geolookup, error) -> Void in
			//print("\(geolookup), \(error)")
			if error != nil {
				LF.alert("Failed to connect to weather service", error!.localizedDescription)
			} else if let desc = geolookup?.response?.error?.type {
				LF.alert("Failed to get location info", "Error type: " + desc)
			} else if let stations = geolookup?.location?.nearby_weather_stations?.airport?.station {
				if stations.count <= 0 {
					LF.alert("No weather station found", "There doesn't seem to be any weather stations around you. Please contact us at support@weatherpov.com")
				} else {
					//print("WEATHER 1st station: \(stations[0])")
					//	Use the first (closest) weather station to get forecast.
					//	TODO: do some calculation to see if it's really the closest one
					let station = stations[0]
					if let city = station.city {
						self.labelCity.text = city
					}
					if let country = station.country?.escape(), let city = station.city?.escape() {
						WP.station = station
						WP.country = country
						WP.city = city
						WPClients.forecast(country, city: city) {
							(forecast, error) -> Void in
							//print("\(forecast), \(error)")
							if let days = forecast?.forecast?.txt_forecast?.forecastday {
								self.reloadTable(days)
							}
							if let days = forecast?.forecast?.simpleforecast?.forecastday {
								self.reloadCarousel(days)
							}
						}
						//	only show tab bar when station info is acquired
						self.tabBarController?.tabBar.hidden = false
					}
				}
			} else {
				LF.alert("Unknown data format from weather service", "Please make sure your app is up to date.")
			}
		}
	}

	func reloadTable(forecastdays: [WPForecastdayModel]) {
		//print("TABLE reload: \(forecastdays)")
		source.counts = [forecastdays.count]
		source.func_cell = {
			(path) -> UITableViewCell in
			let cell = self.table.dequeueReusableCellWithIdentifier("WPForecastCell") as! WPForecastCell
			let forecast = forecastdays[path.row]
			cell.forecast = forecast
			if path.row % 2 == 0 {
				cell.contentView.backgroundColor = .whiteColor()
			} else {
				cell.contentView.backgroundColor = UIColor(rgb: 0xf0f8ff)
			}
			return cell
		}
		table.reloadData()
		UIView.animateWithDuration(0.3) { 
			() -> Void in
			self.table.alpha = 1
		}
	}

//	MARK: carousel

	@IBOutlet var carousel: iCarousel!
	var carouselDays: [WPForecastdayModel]?

	func reloadCarousel(forecastdays: [WPForecastdayModel]) {
		carouselDays = forecastdays
        carousel.type = .InvertedTimeMachine
		carousel.reloadData()
	}

    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
		if let count = carouselDays?.count {
			return count
		}
		return 0
    }

    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
		var controller: WPForecastThumbnailController!
        if (view == nil) {
			controller = WP.storyboard.instantiateViewControllerWithIdentifier("WPForecastThumbnailController") as! WPForecastThumbnailController
			controller.view.frame = CGRect(x:0, y:0, width:200, height:200)
        } else if let view = view as? WPView {
			controller = view.parentViewController as! WPForecastThumbnailController 
		}
		controller.forecast = carouselDays?[index]
		controller.reload()
        return controller.view
    }

	func carousel(carousel: iCarousel, didSelectItemAtIndex index: Int) {
		if let controller = push_identifier("WPForecastDetailController") as? WPForecastDetailController {
			controller.forecast = carouselDays?[index]
		}
	}

//	MARK: actions
	
	@IBAction func actionPresentSetting() {
		present_identifier("WPSettingController")
	}
}

class WPForecastCell: UITableViewCell {
	@IBOutlet var labelTitle:	UILabel!
	@IBOutlet var labelText:	UILabel!
	@IBOutlet var labelPop:		UILabel!
	@IBOutlet var imageIcon:	UIImageView!
	var forecast: WPForecastdayModel!

	override func layoutSubviews() {
		if let title = forecast.title {
			labelTitle.text = title
		} else {
			labelTitle.text = "Unknown"
		}
		if let text = forecast.fcttext where WP.isF {
			labelText.text = text
		} else if let text = forecast.fcttext_metric where WP.isC {
			labelText.text = text
		} else {
			labelText.text = "Unknown"
		}
		labelPop.text = String(format: "%@%", forecast.popPercentage)
		imageIcon.image_load(forecast.icon_url, clear:true)
	}
}

class WPGdayController: LFTableController {
	@IBOutlet var buttonPlay: UIButton!

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		LF.log("GDAY user", WP.user)
	}

	@IBAction func actionPlay() {
		present_identifier("WPLoginController")
	}
}

//	TODO: This is a simplified login/register view controller. There should be 3 view
//	controllers: login, register, and reset password.
class WPLoginController: LFViewController {
	@IBOutlet var fieldPassword:	UITextField!
	@IBOutlet var fieldUsername:	UITextField!
	var isRegistering = false

	override func viewDidLoad() {
		super.viewDidLoad()
		fieldUsername.becomeFirstResponder()
	}
	@IBAction func actionSubmit() {
		signin()
	}
    func signin() {
		if lint() == false {
			return;
		}
		//	try to login first
        WP.show(WP.s.signing_in)
		LF.log("username", fieldUsername.text)
		LF.log("password", fieldPassword.text)
		PFUser.logInWithUsernameInBackground(fieldUsername.text!, password:fieldPassword.text!) {
            (user, error) -> Void in
            WP.hide()
            if error == nil {
                WP.showText(WP.s.signin_successful)
                self.lf_actionDismiss()
                WP.user = user
            } else {
				if let code = error?.code where code == 101 {
					//	Got "invalid login parameters", now we try to sigin up
					self.signup()
				} else {
					WP.showError(error, text:WP.s.signin_failed)
				}
            }
        }
    }
    func signup() {
		//	lint in case we add a new "register" button later
		if lint() == false {
			return
		}
		if isRegistering {
			isRegistering = false
			return
		}
		isRegistering = true
        let user = PFUser()
		user.username = fieldUsername.text
        user.password = fieldPassword.text
		LF.log("user", user)
        WP.show(WP.s.signing_up)
        user.signUpInBackgroundWithBlock() {
            (success, error) -> Void in
            WP.hide()
            if error == nil {
                WP.showText(WP.s.signup_successful)
                self.signin()
            } else {
                WP.showError(error, text:WP.s.signup_failed)
            }
        }
	}
	func lint() -> Bool {
		if fieldUsername.text!.length < 3 {
			WP.showText(WP.s.username_too_short)
			return false
		}
		if fieldUsername.text!.length > 15 {
			WP.showText(WP.s.username_too_long)
			return false
		}
		/*
        if !fieldEmail.text!.is_email() {
            WP.showText(WP.s.invalid_email)
            return false
        }
		*/
        if fieldPassword.text!.length < 4 {
            WP.showText(WP.s.password_too_short)
            return false
        }
		return true
	}
}