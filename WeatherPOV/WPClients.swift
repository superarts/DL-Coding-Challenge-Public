import MapKit

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
	class func astronomy(country: String, city: String, block: ((WPAstronomyResultModel?, NSError?) -> Void)? = nil) {
		let api = String(format:"%@%@/%@.json", WP.api.astronomy, country, city)
		let client = WPRestClient<WPAstronomyResultModel>(api: api)
		client.func_model = block
		client.execute()
	}
}