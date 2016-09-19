### 0.0.2.9000
- Rewrote core function `parseSASscript()` so it calls small functions separately
- Improved algorithm on comments removal
- Improved algorithm on micro define/calls
- Fixed a bug around proc counts
- Added dependency on stringi for its handy manipulation of regular expressions 

### 0.0.1.9000
- Added a new column indicating number of macros defined in each script to output of `pasrseSASscript()`
- Added example figures to README
- Split `drawProcs()` into two functions - `listProcs()` and `drawProcs()`, and both are exported to user


### 0.0.0.9000
Initial Github release.