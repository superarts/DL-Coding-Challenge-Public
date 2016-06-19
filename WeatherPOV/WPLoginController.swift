import UIKit

/**
	Simple `Parse` register / login view.
	TODO: This is a simplified login/register view controller. There should be 3 view:
	controllers: login, register, and reset password.
*/
class WPLoginController: LFViewController {
	@IBOutlet var fieldPassword:	UITextField!
	@IBOutlet var fieldUsername:	UITextField!
	var isRegistering = false

	override func viewDidLoad() {
		super.viewDidLoad()
		fieldUsername.becomeFirstResponder()
	}
	@IBAction func actionSubmit() {
		signin()
	}
    func signin() {
		if lint() == false {
			return;
		}
		//	try to login first
        WP.show(WP.s.signing_in)
		LF.log("username", fieldUsername.text)
		LF.log("password", fieldPassword.text)
		PFUser.logInWithUsernameInBackground(fieldUsername.text!, password:fieldPassword.text!) {
            (user, error) -> Void in
            WP.hide()
            if error == nil {
                WP.showText(WP.s.signin_successful)
                self.lf_actionDismiss()
                WP.user = user
            } else {
				if let code = error?.code where code == 101 {
					//	Got "invalid login parameters", now we try to sigin up
					self.signup()
				} else {
					WP.showError(error, text:WP.s.signin_failed)
				}
            }
        }
    }
    func signup() {
		//	lint in case we add a new "register" button later
		if lint() == false {
			return
		}
		if isRegistering {
			isRegistering = false
			return
		}
		isRegistering = true
        let user = PFUser()
		user.username = fieldUsername.text
        user.password = fieldPassword.text
        user["gday_score"] = 0
		LF.log("user", user)
        WP.show(WP.s.signing_up)
        user.signUpInBackgroundWithBlock() {
            (success, error) -> Void in
            WP.hide()
            if error == nil {
                WP.showText(WP.s.signup_successful)
                self.signin()
            } else {
                WP.showError(error, text:WP.s.signup_failed)
            }
        }
	}
	func lint() -> Bool {
		if fieldUsername.text!.length < 3 {
			WP.showText(WP.s.username_too_short)
			return false
		}
		if fieldUsername.text!.length > 15 {
			WP.showText(WP.s.username_too_long)
			return false
		}
		/*
        if !fieldEmail.text!.is_email() {
            WP.showText(WP.s.invalid_email)
            return false
        }
		*/
        if fieldPassword.text!.length < 4 {
            WP.showText(WP.s.password_too_short)
            return false
        }
		return true
	}
}