# NPS Browser for macOS

A Swift 4 implementation of NPS Browser.

[Download][]

[Screenshots][]

## Usage
**Requires macOS 10.13+**

* Set URLs and extraction preferences in the Preferences window
* Click the refresh button in the corner of the window to pull fresh data from the server. 

Note that the data from the server is stored until you decide to refresh the database.

## Building
Make sure you have [CocoaPods][] installed.
Open a terminal and install the dependencies:
```
pod install
```
Open the .xcworkspace file to open the project.

Build by going to Product > Build.

Export an app bundle by going to Product > Archive > Export.

#### [Changelog][]

## Thanks
* Ann0ying for app icon
* [pkg2zip][]
* [AlamoFire][]
* [Promises][]
* [Queuer][]

[Download]: https://github.com/JK3Y/NPS-Browser-macOS/releases
[Screenshots]: https://imgur.com/gallery/EYLLYoW
[Changelog]: https://github.com/JK3Y/NPS-Browser-macOS/blob/master/CHANGELOG.md
[pkg2zip]: https://github.com/mmozeiko/pkg2zip
[AlamoFire]:https://github.com/Alamofire/Alamofire
[Promises]:https://github.com/google/promises
[Queuer]:https://github.com/FabrizioBrancati/Queuer
[CocoaPods]: https://cocoapods.org
