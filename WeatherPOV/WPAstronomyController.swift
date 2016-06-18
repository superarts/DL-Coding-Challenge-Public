import UIKit

class WPAstronomyController: UITableViewController {
	@IBOutlet var cellCurrentTime:	UITableViewCell!
	@IBOutlet var cellSunrise:	UITableViewCell!
	@IBOutlet var cellSunset:	UITableViewCell!
	@IBOutlet var cellMoonrise:	UITableViewCell!
	@IBOutlet var cellMoonset:	UITableViewCell!

	@IBOutlet var cellIlluminated:	UITableViewCell!
	@IBOutlet var cellMoonAge:		UITableViewCell!
	@IBOutlet var cellMoonPhase:	UITableViewCell!
	@IBOutlet var cellHemisphere:	UITableViewCell!

	override func viewDidLoad() {
		super.viewDidLoad()
	}
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if let country = WP.country, let city = WP.city {
			WPClients.astronomy(country, city: city) {
				(astronomy, error) -> Void in
				//print(astronomy)
				if error != nil {
					LF.alert("Failed to connect to weather service", error!.localizedDescription)
					return
				}
				if let time = astronomy?.moon_phase?.current_time?.str {
					self.cellCurrentTime.detailTextLabel?.text = time
				}
				if let time = astronomy?.sun_phase?.sunrise?.str {
					self.cellSunrise.detailTextLabel?.text = time
				}
				if let time = astronomy?.sun_phase?.sunset?.str {
					self.cellSunset.detailTextLabel?.text = time
				}
				if let time = astronomy?.moon_phase?.moonrise?.str {
					self.cellMoonrise.detailTextLabel?.text = time
				}
				if let time = astronomy?.moon_phase?.moonset?.str {
					self.cellMoonset.detailTextLabel?.text = time
				}
				if let percentage = astronomy?.moon_phase?.percentIlluminated {
					self.cellIlluminated.detailTextLabel?.text = String(format:"%zi%%", percentage)
				}
				if let age = astronomy?.moon_phase?.ageOfMoon {
					self.cellMoonAge.detailTextLabel?.text = String(age)
				}
				if let phase = astronomy?.moon_phase?.phaseofMoon {
					self.cellMoonPhase.detailTextLabel?.text = phase
				}
				if let hemisphere = astronomy?.moon_phase?.hemisphere {
					self.cellHemisphere.detailTextLabel?.text = hemisphere
				}
			}
		}
	}
}