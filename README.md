# About WeatherPOV

This is a proof of concept weather app. It's based on [Weather Underground API](https://www.wunderground.com/weather/api/d/docs?d=data/forecast&MR=1).

## Build and install

- `git clone git@github.com:superarts/DL-Coding-Challenge-Public.git WeatherPOV`
- `cd WeatherPov`
- `pod install`
- `open WeatherPOV.xcworkspace`
  - This launches Xcode, then press `Command+R`
- Also available on `TestFlight`. [Send me an Email](mailto:leo@superarts.org) to get beta access.

## Dependencies

- `LFramework`: REST client, helper classes, etc. Add as source as it's not available as a `pod` yet.
- `pod 'iCarousel'`: Timemachine style carousel.
- `pod 'UIImage+animatedGif'`: Animated GIF.
- `pod 'Parse'`: Cloud-based backend server.
- `pod 'MBProgressHUD'`: Progress HUD for loading screens.

## Features

- General
  - Storyboard
  - Autolayout
  - UIKit
    - `UINavigationController` without `UINavigationBar`
    - `UITabBarController`
    - Customized font with [Interface Builder integration](http://www.superarts.org/LSwift/lswift/lthememanager/gossip/ibinspectable/ui/2015/05/07/introducing-lthememanager-about-ibinspectable.html)
  - Dynamic prototype `UITableViewController`: `LFTableViewController`
  - Static cells `UITableViewController`: `LFTableViewController`
  - Reflection based API client: [LFClient](http://www.superarts.org/LSwift/lswift/lrestclient/gossip/modelling/restful/2015/05/02/about-lrestclient.html)
  - Cloud backend: [Parse](http://parse.com/)
- Daily forecast
  - `CLLocationManager`
  - Carousel: `pod 'iCarousel'`
- Game: G'day
  - Parse login / query
  - `NSTimer`
  - Delayed async dispatch
- Astronomy
- Radar
  - Animated GIF: `pod 'UIImage+animatedGif'`
- Settings
  - `NSUserDefaults`
- Misc
  - `Swift 2.2` syntax
  - TestFlight
  - [Cocoapods](cocoapods.org)
  - [Flurry](flurry.com)
  - [Weather Underground API](https://www.wunderground.com/weather/api/d/docs?d=data/forecast&MR=1)
    - Geolookup
    - Forecast / Forecast 10 days
    - Astronomy
    - Animated Radar + Satellite
  - [Automated build version update](http://www.superarts.org/blog/2014/06/25/automate-ios-version-number)

## Features planned

A map-based social networking system was planned initially. The good thing is that it can have radar overlay, camera, and user generated data (e.g. messages like "It's so sunny! I'm going to the beach!") on the map all together. However, without actual users, it's less cool to have only yourself on the map. So it's replaced by a mini-game `G'day`, in which the leaderboard always shows some users so that the app looks alive.

A more detailed home screen was also planned. The idea was taking advantage of `conditions` and `hourly` APIs and display more data. However, I feel like the technology used t parse and display similar data was already demostrated in `Forecast` and `Astronomy`, so it was not implemented eventually.

## Classes

### General

- WP: `WeatherPOV` general struct
  - Variables
  - Consts
    - APIs
    - Text copies
  - Utilities
- WPView: used in `iCarousel` handling

### View Controllers

Please check `Main.storyboard` for the relationships of all view controllers.

- WPAstronomyController
- WPForecastController
  - WPForecastCell
- WPForecastDetailController
- WPForecastThumbnailController
- WPGdayController
- WPLoginController
- WPRadarController
- WPSettingController

### API Handling

- WPRestClient: RESTful API client
- WPClients: client wrapper class

### Models

- General
  - WPErrorModel
  - WPFeatureModel
  - WPResponseModel
  - WPResultModel
- Geolookup
  - WPGeolocationModel
  - WPStationModel
  - WPAirportModel
  - WPPwsModel
  - WPWeatherStationModel
  - WPLocationModel
  - WPGeolookupResultModel
- Forecast
  - WPDateModel
  - WPTemperatureModel
  - WPQPFModel
  - WPWindModel
  - WPForecastdayModel
  - WPTxtForecastModel
  - WPSimpleForecastModel
  - WPForecastModel
  - WPForecastResultModel
- Astronomy
  - WPTimeModel
  - WPSunPhaseModel
  - WPMoonPhaseModel
  - WPAstronomyResultModel

## About error handling

Most API related errors are handled by LClient. If a property of an object is missing, it remains as `nil`, and it's safe to call `varMayBeNil?.propertyMayBeNil = anotherVarMayBeNil`, since it's technically `[varMayBeNil setPropertyMayBeNil:anotherVarMayBeNil]`: sending a message to a `nil` object simply does nothing in `objc_msgSend`, and [is not considered as an error](http://stackoverflow.com/questions/156395/sending-a-message-to-nil).

## Time log

- 6/16 21:00 - 2:00	= `5 hours`
- 6/17 19:40 - 1:00	= `5.5 hours`
- 6/18 14:00 - 23:30 / 9.5 hours - about 1.5 hours resting = about `8 hours`
- 6/19 14:30 - 17:00 = `2.5 hours`
- Total: about `21 hours`

Misc

- 6/19: spend about 20 minutes to address an issue that prevents the app to work properly in cities like Detroit

## Potential issues

### Geolookup

The following issue of Weather Underground API is logged because some source code of mine may not make sense. Here's the reason.

- 6/16: In [Sydney](https://api.wunderground.com/api/dc60d98175ba0199/geolookup/q/-33.863400,151.211000.json), location info shows Chapin US instead of Sydney AU. [San Francisco](http://api.wunderground.com/api/dc60d98175ba0199/geolookup/q/37.776289,-122.395234.json) shows correct info in the same time. Unfortunately I'll have to use weather station instead of location.
  - [Screenshot in 6/16](https://www.dropbox.com/s/07wfqj2zty6fr4d/Screenshot%202016-06-18%2023.33.39.png?dl=0)
- 6/18: The issue mentioned above is not there anymore.
  - [Screenshot in 6/18](https://www.dropbox.com/s/0d32wz3h6v12wv8/Screenshot%202016-06-18%2023.34.08.png?dl=0)

However, this does introduce a new problem: for cities like [Taipei](https://api.wunderground.com/api/dc60d98175ba0199/geolookup/q/23.6978,120.9605.json), `station` information is not available. Going back to `location` instead of `station` might be a better approach, but I need time to evaluate it.

### [Forecast](http://api.wunderground.com/api/dc60d98175ba0199/forecast/q/AU/Sydney%20Regional%20Office.json)

The following issue prevents some information to be displayed correctly. It can be address from the app side by trying to get the value from `qpf_night`, `qpf_allday`, and `avewind`, but as a POV the app just shows what it has, since in real life scenario the bug is likely to be reported and get fixed by the backend team.

- 6/19: `in` and `mm` in `qpf_day` are `null`, and `dir` in `maxwind` is empty. [Screenshot](https://www.dropbox.com/s/plc6rhb8mz9cdhn/Screenshot%202016-06-19%2016.10.48.png?dl=0)

## Environment

### Development

- `Xcode 7.3.1`
- `Swift 2.2`
- Deployment target: `8.0`
- Device: `iPhone` with `Portrait` orientation

For a POV normally we only target iPhone portrait to reduce potential issue that makes our app look bad, unless the idea is targeted to iPad mainly, etc.

### Test devices

- Simulator
- iPhone 5
- iPhone 6 plus

### And more...

Of course: proper `Tests` and `UITests`! Everyone loves tests if there's more time! [Like this one...](https://bitbucket.org/superarts/hcmessageparser/src/4434fcb7863b24b302d1261dc8eabd7180c4a9a0/Example/Tests/Tests.swift?at=master&fileviewer=file-view-default)

<hr>

# Original README: DL-Coding-Challenge

Welcome to the Detroit Labs coding challenge. 

Please fork this repo and create a branch that includes your name in the branch name (We like to read commits!). Choose from Android, iOS or web to complete this challenge. Comment on what libraries or frameworks you choose to use so we know exactly what code is yours and what is coming from a third-party.

Plan, document, and build your proof of concept then [submit](#submit) it when you are done. 

Proof of Concept scenario description
---
Your Project Manager has just come to you with a potential Client who has requested a WeatherApp _Proof of Concept_! The Client has given us a budget and a laundry list of features. It is your job to build from the feature list to your skill level and defend your implementaton and design decisions. We are trying to win more business from this Very Important Client, and this Proof of Concept needs to impress them in order to move forward. The good news is you have a lot of flexibility with the UI and how you want to display the Weather information. 

The Challenge is to implement features and a UI for a Proof of Concept that looks good and gives insight into what the full app could be in the future.

How many and what features you implement is up to you, but be ready to discuss your strategy and implementation.

* In the [Non-Functional Requirements of Interest](#platformSpecs) section you can find more details about what we are looking for. 
* Please use the [Weather Underground API][1] (There is a lot in the API, show us what you got!).

Ideas for Features
---
* Current Location Weather
* Icons & Menu Icons
* Monthly, Weekly, Daily, Hourly Weather Info
* Map (weather/radar)
* Methods for Multiple UI Themes 
* Pull to Refresh
* Seasonal Conditions (Golf, Sailing, Skiing) 
* Wearable App
* User can display multiple locations 
* User Auth
* Graph (Precipitation, Humidity, Temp, etc.)
* GPS Location
  
*notes* 
* Feel free to add any of your own features, just be prepared to defend them!

<a id="platformSpecs"></a>

Non-Functional Requirements of Interest:
---
* <a id="baciSpec"></a>**Basics**
	* Robust UI (You're probably not a designer. Robust is code for "uses platform standards and standard platform controls correctly and consistently")
	* Understanding of performing asynchronous tasks (thread management and the like)
	* Menu drill down (ex. Food Menu -> Drink Items -> Scroll Through Sodas)
	* Error handling
	* Data persistance (Your own backend or a Service)
	* Multiple endpoints updating a single UI
	* ListView/TableView
		* Different Types of Cells (Height, Editable, add, delete etc.)
* <a id="androidSpec"></a>**Android**
	* Understanding of Fragments and Adapters
* <a id="iosSpec"></a>**iOS**
	* Understanding of Tables

Languages and Frameworks we call friends:
---
* **Languages**
	* Java
	* Ruby
	* JavaScript
	* Php
	* Objective-C
	* Swift
* **Frameworks**
	* Android
	* iOS
	* Sinatra
	* Ruby On Rails
	* Cake
	* Angular.js
* **Other Technologies**
	* Parse
	* Node.js

Our Evaluation Criteria:
---
* Code Quality, Style, and Readablity
* Architecture and Design Decisions (Usable UX, number of features selected to implement, implementation mechanics, patterns used, clever vs. simple)
* Standard Practices (documentation, comments, commit History)
* Completeness of Features Chosen
* UX & Design
* Automated Testing (optional, but if you know how, it'd be nice to see)

**Remember**: this exercise is meant to give you many options and choices in the best way for you to demonstrate, highlight, and communicate your programming ability, design experience, personal style, and coding preferences. We are also looking for how you manage and decide what is important, given a limited amount of time to complete an overwhelming task. *You are not expected to complete this app*, but rather be able to make decisions on what to do with this challenge in the time allotted, describe that decision making process, and then show your work. Getting more done is sometimes better, but if you are able to do a lot of work at a low level of quality and completeness or a little bit of work at a high level of quality and completeness, make an informed choice on which way to go and be prepared to talk about that. Let the challenge scenario guide you.

<a id="submit"></a>
How to Submit
---
* Please fork this repository and create a branch for your project. 
* When you are finished, send a pull request for review.
* Please make sure any services you may use are deployed so we can test your app.
* Once we have reviewed your submission we will contact you for the next steps.

Thank you for applying to Detroit Labs!

<!-- External Links...Reference by Number -->
[1]:http://www.wunderground.com/weather/api/d/docs

# Gossip

This project was built in about 20 hours. One thing that I'm not happy about is the fact that I haven't finished making `LFramework` as a `pod` yet, so it's copied into this project directly. This is never a good approach, and besides this, `LFramework` is still in `underscore_convention`. I'll eventually change it into `CamelCase` due to the fact that there are so many haters of underscore in iOS scene, but I still want to say:

1. `CamelCase` [sucks](http://yosefk.com/blog/ihatecamelcase.html). If you can't blind-type underscore, it doesn't mean that you suck at typing. But don't treat us underscore lovers as freaks. We're equal.
2. In projects I've worked in, I always comply with the existing coding standard and conventions. If you think I'm so shit that I can't even type things right, you're wrong.
3. There are also some conventions I don't like about Apple's standard ones. Again, I can work in a way that is requested and I always respect that. I just want myself to be respected as well.

For example: the old `UIView *view` vs `UIView* view` talk. Of course when you declare 2 or more variables you'll have to use the former, but why would you do that in the first place? The reason why you have to write `UIView *view1, *view2` is to let `gcc/clang etc.` know that both `view1` and `view2` are pointers, and that's why C compiler was implemented in the very beginning. But that doesn't mean it's the best practice. Logically, "defining a variable `view` with type `pointer of type UIView`" have 2 parts: `UIView*`, and `view`.

Of course, other people would like to think it's about declaring a variable `view which is a pointer` of type `UIView`, but mostly you're not really using `*view`, you are using `view`, which is a `UIView*`. Besides, by making `*` not part of `UIView`, there has to be somthing like `- (void)addSubview:(UIView *)view`. I like most whitespace in `C/ObjC` although it doesn't do anything, but in my mind they all have different meanings. For example, `-(void)`looks ugly since `-` doesn't belong to `(void)`, so it's better to leave a whitespace there. And about `if (a > b)` vs `if(a > b)`, the first one is better because it clearly indicates that `if` is a language feature but not a function. And `a > b` is definitely easier to read than `a>b`, at least I wouldn't write something like `i<3`.

Anyway, whitespace should be treated as splitter of sense-groups, but what does the 2nd whitespace do in `- (void)addSubview:(UIView *)view`? Just to say that `view` is a pointer? In my mind `- (void)addSubview:(UIView*)view` means perfect sense. But the problem here is, there are more people hate to type underscore, so Apple chose CamelCase. There are more people chose to use the style that compiler is happy with, although in real life they would split `UIView *view1, *view2` into 2 lines, too. But Apple still chose to use it. As I said again and again, I have no problem with that and I can write code in this way if that's how the team works, but don't address my code as "inconsistent and unclear naming conventions". I wrote my library in the way I'm happy with (using underscore), and used it to build a project that you asked and wrote the project in a way try to make you happy by not using underscore, and that doesn't mean I suck at programming and know nothing about consistency and naming convention.

But of course as I mentioned in the beginning: I should have made `LFramework` as a `pod`, or at least try not to use it to keep coding style consistent. Maybe using `CoreData` makes some people happy, who knows.