import UIKit
import Parse
import SAKit

/**
	A simple game about tapping icons randomly appears on the screen.
	Leaderboard is powered by `Parse`.
*/
class WPGdayController: SATableController {
	@IBOutlet var buttonPlay: UIButton!
	var buttons = [UIButton]()
	// tap 100 buttons in 10 seconds
	let gameMax = 25
	let gameDuration = 10
	var timer: Timer!
	var count = 0
	var score = 0

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		//	update leaderboard silently
		reloadTable()
		//SA.log("GDAY user", WP.user)
		if WP.user != nil {
			buttonPlay.setTitle("PLAY GAME", for:UIControlState())
		}
	}

	@IBAction func actionPlay() {
		if WP.user == nil {
			present_identifier("WPLoginController")
		} else {
			gameStart()
		}
	}

//	MARK: leaderboard table
	func reloadTable() {
		if let query = PFUser.query() {
			query.limit = 100
			query.order(byDescending: "gday_score")
			query.findObjectsInBackground() {
				(users, error) in
				if let users = users as? [PFUser] {
					self.source.counts = [users.count]
					self.source.func_cell = {
						(path) -> UITableViewCell in
						let cell = self.table.dequeueReusableCell(withIdentifier: "WPGdayRankCell")!
						let user = users[path.row]
						if let username = user.username {
							cell.textLabel?.text = String(format: "%zi. %@", path.row + 1, username)
						} else {
							cell.textLabel?.text = "Unknown User"
						}
						if let userScore = user["gday_score"] as? Int {
							cell.detailTextLabel?.text = String(userScore)
						} else {
							cell.textLabel?.text = "Invalid User"
							cell.detailTextLabel?.text = "-"
						}
						if path.row % 2 == 0 {
							cell.contentView.backgroundColor = .white
						} else {
							cell.contentView.backgroundColor = WP.color.tableInterlace
						}
						return cell
					}
					self.table.reloadData()
				}
			}
		}
	}

//	MARK: gameplay
	func gameStart() {
		buttonPlay.setTitle("Start tapping!", for:UIControlState())
		buttonPlay.isEnabled = false
		tabBarController?.tabBar.isHidden = true
	
		score = 0
		count = gameDuration
		timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector:#selector(gameUpdate), userInfo:nil, repeats: true)
		   
		for _ in 1...gameMax {
			let max:UInt32 = UInt32(gameMax) + 1
			var time = Double(arc4random_uniform(max))
			time = sqrt(time * (Double(gameDuration) * Double(gameDuration) / Double(gameMax)))
			if time < 0.5 {
				time = 0.5
			}
			SA.dispatch_delay(time) {
				//	border
				let bw = 50
				let bh = 60
				//	size
				let w:CGFloat = 50
				let h:CGFloat = 50
				let x = CGFloat(arc4random_uniform(UInt32(self.view.w) - UInt32(bw) * 2)) + CGFloat(bw) - w / 2
				let y = CGFloat(arc4random_uniform(UInt32(self.view.h) - UInt32(bh) * 2)) + CGFloat(bh) - h / 2
				let button = UIButton(frame: CGRect(x: x, y: y, width: w, height: h))
				button.enable_border(width:0, color:.blue, is_circle:true)
				button.setImage(UIImage(named:"icon.png"), for:.normal)
				button.addTarget(self, action:#selector(self.gameTapped), for:.touchUpInside)
				button.alpha = 0
				UIView.animate(withDuration: 0.5) { 
					() -> Void in
					button.alpha = 1
				}
				self.view.addSubview(button)
				self.buttons.append(button)
			}
		}
	}
	func gameUpdate() {
		buttonPlay.setTitle(String(count), for:UIControlState())
		count -= 1
		if count == -1 {
			gameEnd()
		}
	}
	func gameEnd() {
		timer.invalidate()
		buttonPlay.setTitle("PLAY GAME", for:UIControlState())
		tabBarController?.tabBar.isHidden = false
		buttonPlay.isEnabled = true
		for button in self.buttons {
			UIView.animate(withDuration: 0.2, animations:{ 
				() -> Void in
				button.alpha = 0
			}, completion: {
				(done) -> Void in
				button.removeFromSuperview()
			}) 
		}
		buttons.removeAll()
		gameSubmit()
	}
	func gameSubmit() {
		var factor = 100
		if let pop = WP.forecast?.pop {
			factor = Int(pop)
		}
		factor = 110 - factor

		if let user = WP.user {
			var scorePrev = 0
			if let prev = user["gday_score"] as? Int {
				scorePrev = prev
				user["gday_score"] = score * factor + prev
			} else {
				user["gday_score"] = score * factor
			}

			WP.show(WP.s.submitting)
			user.saveInBackground() {
				(success, error) in
				WP.hide()
				if error != nil {
					WP.showError(error as NSError?, text:WP.s.submit_failed)
					return
				}
				SA.alert("Congratulations!", 
					String(format: "Your score has been posted!\n\nPrevious: %zi\n\nTapped: %zi\nWeather: x%zi\nThis score: %zi\n\nYOUR TOTAL SCORE: %zi", 
						scorePrev, self.score, factor, self.score * factor, user["gday_score"] as! Int
					) as AnyObject?
				)
				self.reloadTable()
			}

			let scoreObject = PFObject(className: "wp_score")
			scoreObject["user"] = user
			scoreObject["score"] = score
			scoreObject["factor"] = factor
			/*
			scoreObject.saveInBackgroundWithBlock() {
				(success, error) in
				SA.log("SCORE submission result", error)
			}
            */
		}
	}
	func gameTapped(_ button: UIButton) {
		score += 1
		UIView.animate(withDuration: 0.2, animations:{ 
			() -> Void in
			button.alpha = 0
		}, completion: {
			(done) -> Void in
			button.removeFromSuperview()
		}) 
	}
}
