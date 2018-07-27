# Changelog

## v1.3.2
### Added
- Column for PSV Updates that shows the app version number

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
