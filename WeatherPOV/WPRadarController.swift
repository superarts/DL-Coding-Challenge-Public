import UIKit
import SAKit
import UIImage_animatedGif

/**
	A simple rader + satellite view that contains only an animated GIF.
	TODO: use as a transparent overlay on top of a `MapView`.
*/
class WPRadarController: UIViewController {
	@IBOutlet var imageRadar: UIImageView!
	@IBOutlet var labelTitle: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let city = WP.station?.city {
			labelTitle.text = city
		}
		if let api = WP.api.radar() {
			//	TODO: error handling while fetching image failed
			SA.dispatch_main() {
				self.imageRadar.image = UIImage.animatedImage(withAnimatedGIFURL: URL(string: api))
			}
		} else {
			labelTitle.text = WP.s.unknown
			imageRadar.image = nil
		}
	}
}
