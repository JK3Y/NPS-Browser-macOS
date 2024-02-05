# Changelog

## v1.4.7
### Added
- Swift 5 compatibility.
- Download folder and extraction folder are set by default in the Preferences to the Downloads folder but could be different.

### Changed
- macOS 10.12 is no longer supported. App now requires 10.13 to run.
- Carthage is no longer needed. App now uses SPM.
- Remove the build steps for Carthage frameworks.
- Realm updated from the 3.13 to master branch.
- Fuzy updated to the 3.1.3 version.
- Promises updated from 1.2 to the 2.3.1 version.
- Zip updated from the 2.1 to the 2.1.2 version.
- Fixed typo in fuction call makeConcurrentOperation
- Running and tested under Apple M1.

### Fixed
- Download table view constraints for present the action button for each item.

## v1.4.6
### Fixed
- 404.html file on RAP download is now fixed.

## v1.4.5
### Fixed
- Merged an update to fix localization files (@L1cardo)
- Merged a fix for PSV Themes throwing an error about a missing update URL (@AnalogMan151)

## v1.4.4
### Added
- Simplified Chinese localization (Thanks L1cardo!)

### Changed
- macOS 10.10 is no longer supported. App now requires 10.11 to run
- Removed the Update Checker functionality, it didn't always work. May reimplement this in the future.
- UI tweaks in Preferences window
- NPS URLs have been hardcoded

### Fixed
- Fixed a random crash bug related to loading progress window.
- Fixed app crash if an external path used for storing the downloads is not available. Now defaults to Downloads folder.

## v1.4.3
### Added
- Menu option for showing and hiding the sidebar.
- DB migrations for future changes to the database

### Changed
- Code refactoring and cleanup.

### Fixed
- "Show In Finder" button on completed downloads weren't using the correct path
- Bookmarks are now working properly. Bookmarks were being orphaned when the DB is refreshed. Now, bookmarks are given a UUID created from the region/fileType/titleId/contentId of the item.
- "Compat Patches" label in Preferences was slightly overlapped in OS X 10.10
- Download button was displayed over DL options on OS X 10.10
- Artwork images weren't displaying immediately upon startup on OS X 10.10
- Artwork would sometimes just stop appearing altogether on OS X 10.10
- Buttons to resume/stop/view downloaded items weren't showing on OS X 10.10
- Downloads button was enlarged on macOS 10.14 Mojave

## v1.4.2
### Added
- Application can now check for new application updates automatically and download them.
- URL validation on source URLs.
- Game artwork is now fetched directly from the Sony servers. This gives us way faster image loading and reduces resource usage.

### Changed
- Reload button is no longer located in the toolbar. There is a menu titled "Database" that contains an option to reload. There is also a keyboard shortcut available - ⌘R
- Preferences window layout. Is now more legible and is broken up into different setting groups.
- Added a minimum window width to prevent toolbar items from collapsing into an unusable menu
- Changed how user preferences are stored. No more losing your saved configuration after upgrading to the latest version!

### Fixed
- Bug where users running on Mac OS 10.10 Yosemite would have the UI elements placed on top of each other, making the app almost impossible to use.
- Changed downloads icon to an image that's compatible with macOS 10.10
- Bug where if a game didn't have an update on PSN it would crash

## v1.4.1
### Changed
- Changed placeholder image for game artwork

### Fixed
- Bug causing app to crash if no game artwork was found on Renascene.
- Some PSV titles that are cart-only with no zrif weren't being filtered out

## v1.4.0
### Added
- **NOW COMPATIBLE WITH OS 10.10+**
- The side panel is now split horizontally, with the game artwork displayed on the bottom panel. Artwork is taken from Renascene

### Changed
- Database has been changed over from Core Data to Realm. This allows for the database to be Apple-independant and code can be used in future Android and Linux ports.
- Massive code refactoring, cleanup, and optimization

### Fixed
- "Game" label for download checkbox now changes to fileType (DLC, Theme, etc)
- Required FW is now properly formatted to the thousandths place if the FW is missing the second decimal place. Eg. 3.2 -> 3.20

## v1.3.7
### Added
- Downloads/extractions are separated into folders based on console type

### Changed
- Location label in the Preferences window has been changed to "Library Location"
- Removed Update Version column

### Fixed
- Bug where bookmarks weren't being updated properly causing the app to crash.
- Bug where app would crash if NPS library folder was deleted after app started up and before a file was being downloaded
- Bug that was displaying the library location in Preferences with "/NPS Downloads" attached instead of the path to the library's parent folder. This was causing the NPS Downloads folder to be created inside the previous NPS Downloads folder.
- Bug where compat patches weren't being downloaded

## v1.3.6
### Added
- On startup the app checks for the folder "NPS Downloads" at the given download location specified in Preferences. By default this folder is the Downloads folder. If "~/Downloads/NPS Downloads" does not exist it will be created.
- Better logging!
- Compat packs will be extracted in the proper order

### Changed
- The button to download the .pkg files is now multi-purpose. Checkboxes will determine which files specific to that game will be downloaded (base game, updates, compat packs)
- PSV Updates will now no longer be using the NPS TSV file, instead it will be looking up the latest "hybrid package" from Sony's servers and downloading that. If a hybrid package is not available the latest cumulative package will be used. Incremental updates will be handled on the Vita itself.

## v1.3.3
### Fixed
- Compat packs are no longer fetched at the same time as tsv files.

## v1.3.2
### Added
- Column for PSV Updates that shows the app version number
- Local .TSV files can now be used instead of using a URL
- Compat packs for Vita Updates
- Local entries.txt and patch_entries.txt can be used for compat packs instead of URL

### Changed
- Updated app icon (made by @Ann0ying)
- App now uses a custom .dmg file to give it a nice background and a convenient Applications folder to drop the application into

## v1.3.1
### Added
- Compat Pack support!

### Changed
- Fixed bug where downloads that have been resumed will fail
- Bookmarks and Downloads lists now become hightlighted when selected

## v1.3.0
### Added
- PS3 Game support!
- PS3 DLC support!
- PS3 Theme support!
- PS3 Avatar support!

### Changed
- New preferences window (again). The list of URLs is getting so long the window was getting way too tall, so I widened it.
- Fixed bug where completed downloads would show as "stopped" next time the app was loaded
- Now using UUID for each item rather than relying on SHA256 value since PS3 is missing SHA
- Window can now be made full-height of screen

## v1.2.7
### Added
- PS Vita theme support added
- Ability to hide any items with missing download links

### Changed
- Fixed bug where the preferences window would crop if a long path was selected for the download location.
- Now using the forked pkg2zip by Luro02 to unpack PS Vita themes

## v1.2.6
### Added
- A modal window now displays a progress bar showing the progress of fetching the data

### Changed
- Preferences UI has been tweaked
- Core Data storage has been improved

## v1.2.5
### Changed
- Fixed items not being downloaded

## v1.2.4
### Added
- The first row of the master view table is auto-selected
### Changed
- Fixed bug that would make the app crash on startup
- Fixed memory leaks
- Fixed bug where bookmark changes weren't being propagated properly

## v1.2.2
### Added
- Notifications when download/extraction is completed.
- Completed downloads move to bottom of download list
- Button added to download list items to allow resuming a cancelled download.
- Arrow keys can now be used to navigate the data table in the master view
- Concurrent download amount can be changed in the preferences window.
- Bookmarks can now be saved with the star button in the details panel
- Download list will now be saved and restored upon application termination

### Changed
- Changed repository name to "NPS-Browser-macOS" to avoid confusion with original NPS Browser.
- Changed app name to "NPS Browser"
- Fixed a bug that would crash the app when trying to clear download list witih more than 1 item
- UI tweaks
- Application terminates when the red close button is pressed instead of just closing the window

## v1.1
### Added
- This CHANGELOG file to document project changes.
- Added icons created by @Ann0ying
- Ability to sort data by column.
- Added a "Last Modified" column.
- "View file" icon in the downloads window now opens location in Finder.

### Changed
- Changed appicons to the new icons created by @Ann0ying
- Incorrect date formatter was being used in NPSBase, resulting in nil last_modification_date
- CoreDataIO wasn't storing PSP and PSX fetch data
- Removed personal info from comments

## v1.0
### Added
- README containing usage and build instructions.
