# About branch `develop/leoliu`

## Build and install

- `git clone git@github.com:superarts/DL-Coding-Challenge-Public.git WeatherPOV`
- `cd WeatherPov`
- `git checkout develop/leoliu`
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
  - [Automated build version update](http://www.superarts.org/blog/2014/06/25/automate-ios-version-number)

## Features planned

A map-based social networking system was planned initially. The good thing is that it can have radar overlay, camera, and user generated data (e.g. messages like "It's so sunny! I'm going to the beach!") on the map all together. However, without actual users, it's less cool to have only yourself on the map. So it's replaced by a mini-game `G'day`, in which the leaderboard always shows some users so that the app looks alive.

A more detailed home screen was also planned. The idea was taking advantage of `conditions` and `hourly` APIs and display more data. However, I feel like the technology used t parse and display similar data was already demostrated in `Forecast` and `Astronomy`, so it was not implemented eventually.

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

<hr>

# DL-Coding-Challenge
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