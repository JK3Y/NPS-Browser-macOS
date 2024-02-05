# NPS Browser for macOS

A Swift 5 implementation of NPS Browser.\
**Tested and working on macOS Ventura 13.6.1**

![](/Screenshots/main.png?raw=true)

## Features
* Separate Download and Extraction Folders
* Localization in Simplified Chinese
* Bookmarks can be saved by clicking the star icon in the corner of the details panel
* Downloads can be started from the bookmark list
* Downloads can be stopped and resumed at any point, they can also be resumed if the app is closed during download
* Compatibility pack support for FW 3.61+
* Game updates are always the latest version
* Game artwork is displayed

## Usage
* Change or set URLs and extraction preferences in the Preferences window
* From the menu select Database > Reload or press ⌘R
* Compatibility pack URLs must be the raw text file.

## Removal
After moving to trash, run:
```
rm -r ~/Library/Application\ Support/JK3Y.NPS-Browser/
rm -r ~/Library/Caches/JK3Y.NPS-Browser
rm -r ~/Library/Caches/NPS\ Browser
defaults delete JK3Y.NPS-Browser
```

#### [Changelog][]

## Thanks
* Ann0ying for app icon
* Luro02 for the [pkg2zip][] fork
* devnoname120 for [vitanpupdatelinks][]
* L1cardo for Simplified Chinese translation
* danieltarazona for Swift 5 update and Carthage remove

[Changelog]: https://github.com/JK3Y/NPS-Browser-macOS/blob/master/CHANGELOG.md
[pkg2zip]: https://github.com/Luro02/pkg2zip
[vitanpupdatelinks]: https://github.com/devnoname120/vitanpupdatelinks
