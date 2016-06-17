//
//  ViewController.swift
//  WeatherPOV
//
//  Created by Leo on 16/06/2016.
//  Copyright © 2016 Super Art Software. All rights reserved.
//

import UIKit
import MapKit

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

//	MARK: general

class WPErrorModel: LFModel {
	var type: String?
	//var description: String?
}

class WPFeatureModel: LFModel {
	var geolookup: Int = 0
	var forecast: Int = 0
}

class WPResponseModel: LFModel {
	var version: String?
	var termsofService: String?
	var features: WPFeatureModel?
	var error: WPErrorModel?
}

class WPResultModel: LFModel {
	var response: WPResponseModel?
}

//	MARK: geolookup

class WPGeolocationModel: LFModel {
	var city: String?
	var country: String?
	var lat: Float = 0
	var lon: Float = 0
}

class WPStationModel: WPGeolocationModel {
	var state: String?
	var icao: String?
	var neighborhood: String?
	//	in data feed distances appear as int
	var distance_km: Float = 0		
	var distance_mi: Float = 0
}

class WPAirportModel: LFModel {
	var station: [WPStationModel]?
}

class WPPwsModel: WPAirportModel {
}

class WPWeatherStationModel: LFModel {
	var airport: WPAirportModel?
	var pws: WPAirportModel?
}

class WPLocationModel: WPGeolocationModel {
	var type: String?
	var country_iso3166: String?
	var country_name: String?
	var state: String?
	var tz_short: String?
	var tz_long: String?
	var zip: Int = 0
	var magic: Int = 0
	var wmo: Int = 0
	var l: String?
	var requesturl: String?
	var wuiurl: String?
	var nearby_weather_stations: WPWeatherStationModel?
}

class WPGeolookupResultModel: WPResultModel {
	var location: WPLocationModel?
}

//	MARK: forecast

class WPDateModel: LFModel {
	var epoch: String?
	var pretty: String?
	var day: Int = 0
	var month: Int = 0
	var year: Int = 0
	var yday: Int = 0
	var hour: Int = 0
	var min: Int = 0
	var sec: Int = 0
	var isdst: Int = 0
	var monthname: String?
	var monthname_short: String?
	var weekday_short: String?
	var weekday: String?
	var ampm: String?
	var tz_short: String?
	var tz_long: String?
}

class WPTemperatureModel: LFModel {
	//	appear as int
	var fahrenheit:	Float = 0
	var celsius:	Float = 0
	var str: String {
		if WP.isF {
			return String(format: "%.0fºF", fahrenheit)
		}
		return String(format: "%.0fºC", celsius)
	}
}

class WPQPFModel: LFModel {
	//	appear as int
	//var in: Float = 0
	var mm: Float = 0
	var cm: Float = 0
}

class WPWindModel: LFModel {
	//	appear as int
	var mph:		Float = 0
	var kph:		Float = 0
	var dir:		String?
	var degrees:	Float = 0
}

class WPForecastdayModel: LFModel {
	var period:			Int = 0
	var icon:			String?
	var icon_url:		String?
	var pop:			Int = 0

	//	text forecast
	var title:			String?
	var fcttext:		String?
	var fcttext_metric:	String?

	//	simple forecast
	var date:			WPDateModel?
	var high:			WPTemperatureModel?
	var low:			WPTemperatureModel?
	var conditions:		String?
	var skyicon:		String?
	var qpf_allday:		WPTemperatureModel?
	var qpf_day:		WPTemperatureModel?
	var qpf_night:		WPTemperatureModel?
	var snow_allday:	WPTemperatureModel?
	var snow_day:		WPTemperatureModel?
	var snow_night:		WPTemperatureModel?
	var maxwind:		WPWindModel?
	var avewind:		WPWindModel?
	//	appear as int
	var avehumidity:	Float = 0
	var maxhumidity:	Float = 0
	var minhumidity:	Float = 0
}

class WPTxtForecastModel: LFModel {
	var date: String?
	var forecastday: [WPForecastdayModel]?
}

//	Although named as "simple forecast", WPForecastdayModel in
//	WPSimpleForecastModel actually contains more information than
//	the ones in WPTxtForecast (text forecast).
class WPSimpleForecastModel: LFModel {
	var forecastday: [WPForecastdayModel]?
}

class WPForecastModel: LFModel {
	var txt_forecast:	WPTxtForecastModel?
	var simpleforecast:	WPSimpleForecastModel?
}

class WPForecastResultModel: WPResultModel {
	var forecast: WPForecastModel?
}

//	TODO: add generic error handling in RESTClient
class WPRestClient<T: WPResultModel>: LRestClient<T> {
	override init(api url: String, parameters param: LTDictStrObj? = nil) {
		super.init(api: url, parameters: param)
		root = WP.api.root
	}
}

class WPClients {
	class func geolookup(coordinate: CLLocationCoordinate2D, block: ((WPGeolookupResultModel?, NSError?) -> Void)? = nil) {
		let api = String(format:"%@%f,%f.json", WP.api.geolookup, coordinate.latitude, coordinate.longitude)
		let client = WPRestClient<WPGeolookupResultModel>(api: api)
		client.func_model = block
		client.execute()
	}
	class func forecast(country: String, city: String, block: ((WPForecastResultModel?, NSError?) -> Void)? = nil) {
		let api = String(format:"%@%@/%@.json", WP.api.forecast, country, city)
		let client = WPRestClient<WPForecastResultModel>(api: api)
		client.func_model = block
		client.execute()
	}
}

class ViewController: LFTableController, CLLocationManagerDelegate {
	@IBOutlet var labelCity: UILabel!
	var locationManager: CLLocationManager!

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		//	reload UI whenever view is loaded
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
			//	print("\(geolookup), \(error)")
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
					self.labelCity.text = station.city
					if let country = station.country, let city = station.city {
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
					}
				}
			} else {
				LF.alert("Unknown data format from weather service", "Please make sure your app is up to date.")
			}
		}
	}

	func reloadTable(forecastdays: [WPForecastdayModel]) {
		print("TABLE reload: \(forecastdays)")
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
		LF.log("xx", carouselDays?[index])
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
		labelPop.text = String(format: "%i%%", forecast.pop)
		imageIcon.image_load(forecast.icon_url, clear:true)
	}
}

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
		view.enable_border(width:2, color:UIColor(rgb: 0xaaddff), radius: 10)
	}
	func reload() {
		super.viewDidLoad()
		if let weekday = forecast.date?.weekday {
			labelWeekday.text = weekday
		} else {
			labelWeekday.text = "Unknown"
		}
		if let low = forecast.low?.str, let high = forecast.high?.str {
			labelTemperature.text = String(format: "%@ - %@", low, high)
		} else {
			labelTemperature.text = "Unknown"
		}
		if let conditions = forecast.conditions {
			labelCondition.text = conditions
		} else {
			labelCondition.text = "Unknown"
		}
		labelPeriod.text = WP.periodToString(forecast.period)
		labelPop.text = String(format: "%i%%", forecast.pop)
		imageIcon.image_load(forecast.icon_url, clear:true)
	}
}

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