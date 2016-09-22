import UIKit
import Parse
import SAKit
import Flurry_iOS_SDK

protocol FizzBuzz {
    static func getFizzBuzz(i: Int) -> String;
}

/*
class FizzBuzzSpec: QuickSpec {
    override func spec() {
        describe("FizzBuzz") {
            it("can return FizzBuzz string correctly") {
                expect(test.getFizzBuzz(9)) == "Fizz"
                expect(test.getFizzBuzz(15)) == "FizzBuzz"
                expect(test.getFizzBuzz(30)) == "FizzBuzz"
                expect(test.getFizzBuzz(32)) == "32"
            }
        }
    }
}
*/

class MyFizzBuzz: FizzBuzz {
    class func getFizzBuzz(i: Int) -> String {
        if i % 15 == 0 {
            return "FizzBuzz"
        }
        if i % 3 == 0 {
            return "Fizz"
        } else if i % 5 == 0 {
            return "Buzz"
        }
        return String(i)
    }
}

func testFizzBuzz() {
    for i in 1 ... 100 {
        print("\(i): \(MyFizzBuzz.getFizzBuzz(i))")
    }
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		//UIFont.print_all()
		initParse(launchOptions)
		initFlurry()
		//test1()	//	la
		//test2()	//	thailand lazada
		var s = "1A 2F 2H"
		test3(2, &s)
		return true
	}

func test3(N : Int, inout _ S : String) -> Int {
    // write your code in Swift 2.2 (Linux)
    var count = 0
	let array = S.characters.split{$0 == " "}.map(String.init)
    for i in 1 ... N {
		//	ABC: all seats need to be available
		if !array.contains(String(i) + "A") && 
			!array.contains(String(i) + "B") && 
			!array.contains(String(i) + "C") {
			count += 1
		}
		//	DEFG: either DEF or EFG need to be available
		if (!array.contains(String(i) + "D") && 
			!array.contains(String(i) + "E") && 
			!array.contains(String(i) + "F")) || 
			(!array.contains(String(i) + "E") && 
			!array.contains(String(i) + "F") && 
			!array.contains(String(i) + "G")){
			count += 1
		}
		//	HJK: all seats need to be available
		if !array.contains(String(i) + "H") && 
			!array.contains(String(i) + "J") && 
			!array.contains(String(i) + "K") {
			count += 1
		}
    }
	print("----")
	print(count)
    return count
}

func sum(array: [Int], head: Int, tail a_tail: Int) -> Int {
	var tail = a_tail
    var ret = 0
	if tail >= array.count {
		tail = array.count - 1
	}
	if head > tail {
		return 0
	}
    for i in head ... tail {
        ret += array[i]
    }
    return ret
}

func solution1(inout A : [Int]) -> Int {
    // write your code in Swift 2.2 (Linux)
	for i in 0 ..< A.count - 1 {
		let sum1 = sum(A, head: 0, tail: i - 1)
		let sum2 = sum(A, head: i + 1, tail: A.count - 1)
		if sum1 == sum2 {
			return i
		}
	}
    return -1
}

internal func solution2(inout A : [Int]) -> Int {
    // write your code in Swift 2.2 (Linux)
    var i = 0
    var count = 1
	while A[i] != -1 && count < A.count && A[i] < A.count && i < A.count {
        i = A[i]
        count += 1
    }
    return count
}

func weekday_to_int(weekday: String) -> Int {
    let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var i: Int! = weekdays.indexOf(weekday)
    if i == nil {
        i = 0   // should be -1 but weekday is assumed to be valid
    }
    return i
}

func month_to_int(month: String) -> Int {
    let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var i: Int! = months.indexOf(month)
    if i == nil {
        i = 0   // should be -1 but weekday is assumed to be valid
    }
    return i
}

func is_leap_year(year: Int) -> Bool {
	//	"Assume that a year is a leap year if it is devisible by 4": so it's not on earth and we cannot use earth calander
	if year < 0 || year > 999999999 {
		return false
	}
	return year % 4 == 0
}

func days_of_month(month: Int, year: Int) -> Int {
	let days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	if month > 11 {
		return 0
	}
	if month == 1 && is_leap_year(year) {
		return 29
	}
	return days[month]
}

func first_monday(month: String, year: Int, weekday: String) -> Int {
	//print(weekday)
	//print(weekday_to_int(weekday))
	var days = 0
	for i in 0 ..< month_to_int(month) {
		days += days_of_month(i, year: year)
	}
	return (10 - (days + weekday_to_int(weekday)) % 7) % 7
}

internal func solution(Y : Int, inout _ A : String, inout _ B : String, inout _ W : String) -> Int {
    // write your code in Swift 2.2 (Linux)
    //day(B) - day(A) - week(A) % 7
    var ret = 0
    for i in month_to_int(A) ... month_to_int(B) {
        ret += days_of_month(i, year: Y)
    }
	//print(ret)
	print(first_monday(A, year: Y, weekday: W))
    return (ret - weekday_to_int(W) - first_monday(A, year: Y, weekday: W) - 2) / 7
}

internal func solution3(A: [Int]) -> Int {
    // write your code in Swift 2.2 (Linux)
    var count = 0
    for i in 0 ..< A.count - 1 {
        for ii in i + 1 ..< A.count {
			print("\(i) vs \(ii)")
            if A[i] == A[ii] {
                count += 1
                if (count >= 1000000000) {
                    return count
                }
            }
        }
    }
    return count
}

	func test2() {
		print("test2 ----");
		//print(sum([1, 2, 3, 4, 5], head: 2, tail: 5))
		//var array = [-1, 3, -4, 5, 1, -6, 2, 1]
		//var array = [1, 4, 3, -1, 2]
		//print(solution(&array))
		print(weekday_to_int("Tuesdays"))
		print(month_to_int("Octobers"))
		print(is_leap_year(2000))
		print(is_leap_year(2001))
		print(is_leap_year(2008))
		print(days_of_month(1, year: 2008))
		print(days_of_month(11, year: 2008))
		print(days_of_month(1, year: 2007))
		var m1 = "April"
		var m2 = "May"
		var week = "Wednesday"
		print("--")
		print(first_monday("January", year: 2014, weekday: "Friday"))
		print(first_monday("February", year: 2014, weekday: "Friday"))
		print(first_monday("March", year: 2014, weekday: "Friday"))
		print(first_monday("April", year: 2014, weekday: "Friday"))
		print(first_monday("May", year: 2014, weekday: "Friday"))
		print("--")
		print(first_monday("January", year: 2015, weekday: "Friday"))
		print(first_monday("February", year: 2015, weekday: "Friday"))
		print(first_monday("March", year: 2015, weekday: "Friday"))
		print(first_monday("April", year: 2015, weekday: "Friday"))
		print(first_monday("May", year: 2015, weekday: "Friday"))
		print("--")
		print(first_monday("June", year: 2014, weekday: "Friday"))
		print(first_monday("July", year: 2014, weekday: "Friday"))
		print(first_monday("August", year: 2014, weekday: "Friday"))
		print(first_monday("September", year: 2014, weekday: "Friday"))
		print(first_monday("October", year: 2014, weekday: "Friday"))
		print("--")
		print(solution(2014, &m1, &m2, &week))
		print(solution3([3, 5, 6, 3, 3, 5]))
		print("test2 ----");
	}

	func applicationWillResignActive(application: UIApplication) {
	}

	func applicationDidEnterBackground(application: UIApplication) {
	}

	func applicationWillEnterForeground(application: UIApplication) {
	}

	func applicationDidBecomeActive(application: UIApplication) {
	}

	func applicationWillTerminate(application: UIApplication) {
	}

	func initParse(launchOptions: [NSObject: AnyObject]?) {
		//	Parse keys for project "playground": production keys should be
		//	obfuscated and shouldn't be pushed to a public repo.
		let applicationId	= "C4MCodjI5pFuctdLMDKSjgGSybVm9XWLFc7cmDQF"
		let clientKey		= "ik5E1yuhvPwUqiUBc6QyhSN3NSz3KyQmLWtOWHWw"
		Parse.setApplicationId(applicationId, clientKey:clientKey)

		PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block:{
			(success, error) in
			SA.log("ANALYTICS success", success)
		})

		//PFUser.logInWithUsername("no@name.com", password:"asdf")
        if let user = PFUser.currentUser() {
            WP.user = user
        } else {
			//PFUser.enableAutomaticUser()
		}
		//	test: disable auto login
		//WP.user = nil
		SA.log("user", WP.user)
		PFQuery.clearAllCachedResults()
	}

	func initFlurry() {
		//	Flurry key should be obfuscated and shouldn't be pushed to a public repo.
		Flurry.setDebugLogEnabled(false)
		Flurry.startSession("FM9FG6CP4BYXT5XCYD7D")
	}

	func test1() {
		print("test")
		testFizzBuzz()
		print(getMultiplicationTable(12))
		for i in 0 ... 24 {
			print(getClock(i, isStartZero:true, isNoonAM: true))
		}
	}

	func testFizzBuzz() {
		for i in 1 ... 100 {
			print("\(i): \(MyFizzBuzz.getFizzBuzz(i))")
		}
	}

	func getMultiplicationTable(max: Int) -> String {
		var ret = ""
		for i in 1 ... max {
			for ii in 1 ... max {
				ret += String(i * ii)
				ret += "\t"
			}
			ret += "\n"
		}
		return ret
	}
	//  US: 12:00 AM, 1:00 AM, ..., 11:00 AM, 12:00 PM, 01:00 PM, ..., 11:00 PM, 12:00 AM
	//  tricky 12:00 AM/PM: https://en.wikipedia.org/wiki/12-hour_clock
	//  Default: US
	//  US: isStartZero: false, isNoonAM: false
	//  JP: isStartZero: true, isNoonAM: true
	func getClock(hour: Int, isStartZero: Bool = false, isNoonAM: Bool = false) -> String {
		//  boundary checking
		if hour < 0 {
			return "Warning: input should not be less than 0"
		} else if hour > 24 {
			return "Warning: input should not be larger than 24"
		}
		
		var hh = hour
		var period = "AM"
		if hh > 12 {
			hh -= 12
			period = "PM"
		}
		if hh == 0 && !isStartZero {
			hh = 12
		} else if hh == 12 && !isNoonAM {
			period = "PM"
		}
		
		return String(format: "%02zi:00 %@", hh, period) 
	}
}