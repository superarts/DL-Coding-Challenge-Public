import UIKit
import SAKit

/**
	Astronomy info. It contains a static table view so most works are done in `Main.storyboard`.
	TODO: add moon phase images. (Sweet memory: my first iOS app in App Store was about moon phase.)
*/
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

	@IBOutlet var labelTitle: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let city = WP.station?.city {
			labelTitle.text = city
		}
		if let station = WP.station {
			WPClients.astronomy(station) {
				(astronomy, error) -> Void in
				//print(astronomy)
				if error != nil {
					SA.alert("Failed to connect to weather service", error!.localizedDescription as AnyObject?)
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
					self.cellIlluminated.detailTextLabel?.text = String(format:"%.0f%%", percentage)
				}
				if let age = astronomy?.moon_phase?.ageOfMoon {
					self.cellMoonAge.detailTextLabel?.text = age
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
