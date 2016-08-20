import SAKit

//	MARK: general

class WPErrorModel: SAModel {
	var type: String?
	//var description: String?
}

class WPFeatureModel: SAModel {
	var geolookup:	Int = 0
	var forecast:	Int = 0
	var astronomy:	Int = 0
}

class WPResponseModel: SAModel {
	var version:		String?
	var termsofService:	String?
	var features:		WPFeatureModel?
	var error:			WPErrorModel?
}

class WPResultModel: SAModel {
	var response:	WPResponseModel?
}

//	MARK: geolookup

class WPGeolocationModel: SAModel {
	var city: String?
	var country: String?
	var lat: Float = 0
	var lon: Float = 0
}

class WPStationModel: WPGeolocationModel {
	var state:	String?
	var icao:	String?
	var neighborhood:	String?
	//	in data feed distances appear as int
	var distance_km:	Float = 0		
	var distance_mi:	Float = 0
}

class WPAirportModel: SAModel {
	var station: [WPStationModel]?
}

class WPPwsModel: WPAirportModel {
}

class WPWeatherStationModel: SAModel {
	var airport: WPAirportModel?
	var pws: WPAirportModel?
}

class WPLocationModel: WPGeolocationModel {
	var type:				String?
	var country_iso3166:	String?
	var country_name:		String?
	var state:		String?
	var tz_short:	String?
	var tz_long:	String?
	var zip:		String?
	var magic:		String?
	var wmo:		String?
	var l:			String?
	var requesturl:	String?
	var wuiurl:		String?
	var nearby_weather_stations: WPWeatherStationModel?
}

class WPGeolookupResultModel: WPResultModel {
	var location: WPLocationModel?
}

//	MARK: forecast

class WPDateModel: SAModel {
	var epoch:	String?
	var pretty:	String?
	var day:	Int = 0
	var month:	Int = 0
	var year:	Int = 0
	var yday:	Int = 0
	var hour:	Int = 0
	var min:	String?
	var sec:	Int = 0
	var isdst:	String?
	var monthname:			String?
	var monthname_short:	String?
	var weekday_short:		String?
	var weekday:	String?
	var ampm:		String?
	var tz_short:	String?
	var tz_long:	String?
}

class WPTemperatureModel: SAModel {
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

class WPQPFModel: SAModel {
	//	appear as int
	//var in: Float = 0
	var inch: Float {
		//	FIXME: currently swift keywords cannot be property name.
		//	Property "raw" provides a work-around by access raw data.
		if let f = raw?["in"] as? Float {
			return f
		}
		return 0
	}
	var mm: Float = 0
	var cm: Float = 0
	var str: String {
		if WP.isInch {
			return String(format: "%.02f inch", inch)
		}
		if cm != 0 {
			return String(format: "%.02f cm", cm)
		}
		if mm != 0 {
			return String(format: "%.0f mm", mm)
		}
		return "0 cm"
	}
}

class WPWindModel: SAModel {
	//	appear as int
	var mph:		Float = 0
	var kph:		Float = 0
	var dir:		String?
	var degrees:	Float = 0
	var speed: String {
		if WP.isMile {
			return String(format: "%.0f mph", mph)
		}
		return String(format: "%.0f kph", kph)
	}
}

class WPForecastdayModel: SAModel {
	var period:			Int = 0
	var icon:			String?
	var icon_url:		String?
	var pop:			Float = 0
	var popPercentage:	String {
		return String(format: "%.0f%%", pop)
	}

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
	var qpf_allday:		WPQPFModel?
	var qpf_day:		WPQPFModel?
	var qpf_night:		WPQPFModel?
	var snow_allday:	WPQPFModel?
	var snow_day:		WPQPFModel?
	var snow_night:		WPQPFModel?
	var maxwind:		WPWindModel?
	var avewind:		WPWindModel?
	//	appear as int
	var avehumidity:	Float = 0
	var maxhumidity:	Float = 0
	var minhumidity:	Float = 0
}

class WPTxtForecastModel: SAModel {
	var date: String?
	var forecastday: [WPForecastdayModel]?
}

//	Although named as "simple forecast", WPForecastdayModel in
//	WPSimpleForecastModel actually contains more information than
//	the ones in WPTxtForecast (text forecast).
class WPSimpleForecastModel: SAModel {
	var forecastday: [WPForecastdayModel]?
}

class WPForecastModel: SAModel {
	var txt_forecast:	WPTxtForecastModel?
	var simpleforecast:	WPSimpleForecastModel?
}

class WPForecastResultModel: WPResultModel {
	var forecast: WPForecastModel?
}

//	Astronomy

class WPTimeModel: SAModel {
	var hour:	Float = 0
	var minute:	Float = 0
	var str: String {
		return String(format:"%02.0f:%02.0f", hour, minute)
	}
}

class WPSunPhaseModel: SAModel {
	var sunrise:	WPTimeModel?
	var sunset:		WPTimeModel?
}

//	WPMoonPhaseModel contains sunrise and sunset sometimes, but they shouldn't be
//	used. For sunrise and sunset we should always use WPSunPhaseModel.
//	Inconsistent spellings are from original API, see:
//	http://api.wunderground.com/api/dc60d98175ba0199/astronomy/q/AU/Sydney.json
class WPMoonPhaseModel: WPSunPhaseModel {
	var percentIlluminated:	Float = 0
	var ageOfMoon: String?
	var phaseofMoon: String?
	var hemisphere: String?

	var current_time:	WPTimeModel?
	var moonrise:	WPTimeModel?
	var moonset:	WPTimeModel?
}

class WPAstronomyResultModel: WPResultModel {
	var sun_phase: WPSunPhaseModel?
	var moon_phase: WPMoonPhaseModel?
}