// user.js — Firefox user preferences
//
// This needs linking into ~/.mozilla/firefox/*.default*/ and then it will
// override settings in prefs.js.


// Don't automatically play videos:
user_pref("media.autoplay.default", 5);

// Heed userChrome.css and userContent.css:
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
