# Changelog

## In Progress - 1.2

### Added
- Notifications when download/extraction is completed.
- Completed downloads move to bottom of download list
- Button added to download list items to allow resuming a cancelled download.
- Arrow keys can now be used to navigate the data table in the master view
- Concurrent download amount can be changed in the preferences window.
- Bookmarks can now be saved with the star button in the details panel

### Changed
- Changed repository name to "NPS-Browser-macOS" to avoid confusion with original NPS Browser.
- Changed app name to "NPS Browser"
- Fixed a bug that would crash the app when trying to clear download list witih more than 1 item
- UI tweaks
- Application terminates when the red close button is pressed instead of just closing the window

## 1.1 - 2018-06-08
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

## 1.0 - 2018-06-03
### Added
- README containing usage and build instructions.
