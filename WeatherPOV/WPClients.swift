import MapKit
import SAKit

/**
    RESTful API client
*/
//	TODO: add generic error handling in RESTClient
class WPRestClient<T: WPResultModel>: SARESTClient<T> {
	override init(api url: String, parameters param: SADictStrObj? = nil) {
		super.init(api: url, parameters: param)
		root = WP.api.root
	}
}

/**
	RESTful API client wrapper class with helper function(s)
*/
class WPClients {
	class func geolookup(_ coordinate: CLLocationCoordinate2D, block: ((WPGeolookupResultModel?, NSError?) -> Void)? = nil) {
		let api = String(format:"%@%f,%f.json", WP.api.geolookup, coordinate.latitude, coordinate.longitude)
		let client = WPRestClient<WPGeolookupResultModel>(api: api)
		client.func_model = block
		print("geolookup: \(api)")
		client.execute()
	}
	class func forecast(_ station: WPStationModel, block: ((WPForecastResultModel?, NSError?) -> Void)? = nil) {
		let api = String(format:"%@%@.json", WP.api.forecast, getLocationQuery(station))
		let client = WPRestClient<WPForecastResultModel>(api: api)
		client.func_model = block
		client.execute()
	}
	class func astronomy(_ station: WPStationModel, block: ((WPAstronomyResultModel?, NSError?) -> Void)? = nil) {
		let api = String(format:"%@%@.json", WP.api.astronomy, getLocationQuery(station))
		let client = WPRestClient<WPAstronomyResultModel>(api: api)
		client.func_model = block
		client.execute()
	}
	class func getLocationQuery(_ station: WPStationModel) -> String {
		//	In city like Sydney AU, state can be empty.
		var country = ""
		var state = ""
		var city = ""
		if let s = station.country?.escape() {
			country = "/" + s
		}
		if let s = station.state?.escape() {
			state = "/" + s
		}
		if let s = station.city?.escape() {
			//	e.g. France/Paris-Montsouris doesn't work
			city = "/" + s.replacingOccurrences(of: "-", with: "%20")
		}
		return country + state + city
	}
}