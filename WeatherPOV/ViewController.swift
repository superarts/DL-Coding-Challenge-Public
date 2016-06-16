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
	}
}

class WPErrorModel: LFModel {
	var type: String?
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
	var distance_km: Float = 0		//	in data feed distances appear as int
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

class WPGeolookupModel: LFModel {
	var response: WPResponseModel?
	var location: WPLocationModel?
}

class WPRestClient<T: WPGeolookupModel>: LRestClient<T> {
	override init(api url: String, parameters param: LTDictStrObj? = nil) {
		super.init(api: url, parameters: param)
		root = WP.api.root
	}
}

class WPClients {
	class func geolookup(coordinate: CLLocationCoordinate2D, block: ((WPGeolookupModel?, NSError?) -> Void)? = nil) {
		let api = String(format:"%@%f,%f%@", WP.api.geolookup, coordinate.latitude, coordinate.longitude, ".json")
		let client = WPRestClient<WPGeolookupModel>(api: api)
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
			(response, error) -> Void in
			print("\(response), \(error)")
		}
	}
}
