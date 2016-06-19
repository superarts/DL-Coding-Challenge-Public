import UIKit
import MapKit

/**
    First screen of the app: 10 days forecast. Tab bar is hidden until locatio is updated.
	`LFTableController` is a helper class in `LFoundation.swift` to handle 1 or more table views within.
*/
class WPForecastController: LFTableController, CLLocationManagerDelegate {
	@IBOutlet var labelCity: UILabel!
	var locationManager: CLLocationManager!
	var isTarBarHidden = true
	var isLoadingWeather = false

	override func viewDidLoad() {
		super.viewDidLoad()
		tabBarController?.tabBar.hidden = true
		table.alpha = 0
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		//	Update location and reload UI while switching tabs, etc.
		//	TODO: pull to reload
		isLoadingWeather = false
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
			//	LF.log("LOCATION updated", location)
			//	Stop updating as soon as a recent location is obtained.
			self.locationManager.stopUpdatingLocation()
			//	simple tests
			//loadWeather(CLLocation(latitude: 42.3314, longitude: -83.0458))		//	detroit
			//loadWeather(CLLocation(latitude: 40.7128, longitude: -74.0059))		//	new york
			//loadWeather(CLLocation(latitude: 48.8566, longitude: 2.3522))			//	paris
			//loadWeather(CLLocation(latitude: 23.6978, longitude: 120.9605))		//	taipei
			loadWeather(location)
			break
		}
	}

	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		print("LOCATION error: \(error)")
		//	TODO: check authorization status and prompt user to change this in settings. 
		//	For a POV we always grant permission so minimal effect was spent here.
		WP.showError(error, text: WP.s.location_failed)
	}

	func loadWeather(location: CLLocation) {
		if isLoadingWeather {
			return
		}
		isLoadingWeather = true
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
					print("WEATHER 1st station: \(stations[0])")
					//	Use the first (closest) weather station to get forecast.
					//	TODO: do some calculation to see if it's really the closest one
					let station = stations[0]
					if let city = station.city {
						self.labelCity.text = city
					}
					WP.station = station
					WPClients.forecast(station) {
						(forecast, error) -> Void in
						//print("\(forecast), \(error)")
						if let days = forecast?.forecast?.txt_forecast?.forecastday {
							self.reloadTable(days)
							if self.isTarBarHidden {
								self.isTarBarHidden = false
								self.tabBarController?.tabBar.hidden = false
							}
						}
						if let days = forecast?.forecast?.simpleforecast?.forecastday {
							self.reloadCarousel(days)
							//	only show tab bar when station and forecast info is acquired
						}
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
				cell.contentView.backgroundColor = WP.color.tableInterlace
			}

			//	save today's forecast
			if path.row == 0 {
				WP.forecast = forecast
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

/**
    Daily forecast table view cell.
*/
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
			labelTitle.text = WP.s.unknown
		}
		if let text = forecast.fcttext where WP.isF {
			labelText.text = text
		} else if let text = forecast.fcttext_metric where WP.isC {
			labelText.text = text
		} else {
			labelText.text = WP.s.unknown
		}
		labelPop.text = String(format: "%@%", forecast.popPercentage)
		imageIcon.image_load(forecast.icon_url, clear:true)
	}
}