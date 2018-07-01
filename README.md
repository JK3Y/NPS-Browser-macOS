# NPS Browser for macOS

A Swift 4 implementation of NPS Browser.

#### [Download][]

#### [Screenshots][]

## Usage
**Requires macOS 10.13+**

* Set URLs and extraction preferences in the Preferences window
* Click the refresh button in the corner of the window to pull fresh data from the server. 

## Removal
After moving to trash, run:
```
rm -r ~/Library/Application\ Support/NPS\ Browser/
rm -r ~/Library/Caches/JK3Y.NPS-Browser
defaults delete JK3Y.NPS-Browser
```

## Features
* Bookmarks can be saved by clicking the star icon in the corner of the details panel.
* Downloads can be started from the bookmark list
* Downloads can be stopped and resumed at any point, they can also be resumed if the app is closed during download.

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
* Luro02 for the [pkg2zip][] fork

### Dependencies
* [AlamoFire][]
* [Promises][]
* [Queuer][]

[Download]: https://github.com/JK3Y/NPS-Browser-macOS/releases
[Screenshots]: https://imgur.com/gallery/9VLxpOm
[Changelog]: https://github.com/JK3Y/NPS-Browser-macOS/blob/master/CHANGELOG.md
[pkg2zip]: https://github.com/Luro02/pkg2zip
[AlamoFire]:https://github.com/Alamofire/Alamofire
[Promises]:https://github.com/google/promises
[Queuer]:https://github.com/FabrizioBrancati/Queuer
[CocoaPods]: https://cocoapods.org
