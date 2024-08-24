// user.js — Firefox user preferences
//
// This needs linking into ~/.mozilla/firefox/*.default*/ and then it will
// override settings in prefs.js.


// Don't automatically play videos:
user_pref("media.autoplay.default", 5);

// Heed userChrome.css and userContent.css:
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Ctrl+Tab switches between most recently used tabs:
user_pref("browser.ctrlTab.sortByRecentlyUsed", true);

// Ctrl+Plus increases the text size only:
user_pref("browser.zoom.full", true);

// Tab goes straight to form fields, not through links:
user_pref("accessibility.tabfocus", 3);

// Stop animating images once they've been through once:
user_pref("image.animation_mode", 'once');
