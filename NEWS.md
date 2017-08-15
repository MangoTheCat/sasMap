### 1.0
- Renamed and rewrote many core functions
- Moved network/plotting/app features to dev branch

### 0.0.2.9000
- Rewrote core function `parseSASscript()` so it calls small functions separately. Specifically, improved algorithm of comment removal, added micro define/calls so the stats information is more accurate.
- Added unit tests
- Added dependency on stringi for its handy manipulation of regular expressions
- Interactive network improved. Top level scripts, low level scripts and macros can be visually distinguished.
- Added a shiny app.
- Specified license.

### 0.0.1.9999
- Amended search for proc calls so doesn't have false positives for words which start with "proc" (thanks @thisisnic)

### 0.0.1.9000
- Added a new column indicating number of macros defined in each script to output of `pasrseSASscript()`
- Added example figures to README
- Split `drawProcs()` into two functions - `listProcs()` and `drawProcs()`, and both are exported to user


### 0.0.0.9000
Initial Github release.