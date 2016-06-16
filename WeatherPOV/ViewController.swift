//
//  ViewController.swift
//  WeatherPOV
//
//  Created by Leo on 16/06/2016.
//  Copyright © 2016 Super Art Software. All rights reserved.
//

import UIKit
import MapKit

struct WP {
	struct api {
		static let key = "dc60d98175ba0199"
		static let root = "https://api.wunderground.com/api/" + key + "/"
		static let geolookup = "geolookup/q/"
		static let forecast = "forecast/q/"
	}
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
	var title:			String?
	var fcttext:		String?
	var fcttext_metric:	String?
	var pop:			Int = 0

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
//	the ones in WPTxtForecast.
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

class ViewController: UIViewController, CLLocationManagerDelegate {
	var locationManager: CLLocationManager!

	override func viewDidLoad() {
		super.viewDidLoad()
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
					if let country = station.country, let city = station.city {
						WPClients.forecast(country, city: city) {
							(forecast, error) -> Void in
							print("\(forecast), \(error)")
						}
					}
				}
			} else {
				LF.alert("Unknown data format from weather service", "Please make sure your app is up to date.")
			}
		}
	}
}
