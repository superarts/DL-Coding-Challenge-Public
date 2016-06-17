import UIKit

class WPRadarController: UIViewController {
	@IBOutlet var imageRadar: UIImageView!
	@IBOutlet var labelTitle: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
	}
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if let api = WP.api.radar, let city = WP.city {
			LF.log("API", api)
			labelTitle.text = city
			//	TODO: error handling while fetching image failed
			LF.dispatch_main() {
				self.imageRadar.image = UIImage.animatedImageWithAnimatedGIFURL(NSURL(string: api))
			}
		} else {
			labelTitle.text = "Unknown"
			imageRadar.image = nil
		}
	}
}