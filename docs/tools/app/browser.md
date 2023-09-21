<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [firefox](#firefox)
  - [restart firefox](#restart-firefox)
  - [customized firefox style](#customized-firefox-style)
- [chrome](#chrome)
  - [shortcut](#shortcut)
  - [download](#download)
  - [tips](#tips)
- [chromium](#chromium)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> references:
> - [CSS Selector Reference](https://www.w3schools.com/cssref/css_selectors.asp)
> - [CSS Selectors](https://www.w3schools.com/css/css_selectors.asp)
> - [Understand ‘+’, ‘>’ and ‘~’ symbols in CSS Selector](https://techbrij.com/css-selector-adjacent-child-sibling)
> - [10 CSS3 Properties You Need to Be Familiar With](https://code.tutsplus.com/tutorials/the-30-css-selectors-you-must-memorize--net-16048)
> - [CSS: Cascading Style Sheets](https://developer.mozilla.org/en-US/docs/Web/CSS)
>   - [:is()](https://developer.mozilla.org/en-US/docs/Web/CSS/:is)
> - [A list of Font Awesome icons and their CSS content values](https://astronautweb.co/snippet/font-awesome/)
{% endhint %}

## firefox
### [restart firefox](https://www.msftnext.com/how-to-restart-firefox-without-closing-tabs/)
```
about:restartrequired
```

### customized firefox style
#### [`userChrome.css`](https://www.userchrome.org/how-create-userchrome-css.html)
> - [Profiles - Where Firefox stores your bookmarks, passwords and other user data](https://support.mozilla.org/en-US/kb/profiles-where-firefox-stores-user-data)
> - [How To Customise Firefox 57+ UI with userChrome.css](http://forums.mozillazine.org/viewtopic.php?f=38&t=3037817&sid=ac9ffa618d12e89c0346c1f4963d2bba)
> - [Aris-t2/CustomCSSforFx](https://github.com/Aris-t2/CustomCSSforFx/tree/master/classic)

- Steps:
  - open your currently active [profile folder](http://kb.mozillazine.org/Profile_folder#Folders)
  - create a new folder named chrome
  - create a desktop shortcut (alias) to the chrome folder for easier future access
  - make sure your OS is set to show you file extensions like .txt and .css
  - create a new text file inside the chrome folder named [userChrome.css](http://kb.mozillazine.org/UserChrome.css)
  - change a preference in Firefox so it looks for your files at startup (in Firefox 69+)

- [Unlock custom CSS usage in Firefox 69 and newer](https://github.com/Aris-t2/CustomCSSforFx#unlock-custom-css-usage-in-firefox-69-and-newer)
  - `about:config`
  - `toolkit.legacyUserProfileCustomizations.stylesheets`
  - `true`

- [Where to find Firefox profile folder? The correct location for user styles](https://github.com/Aris-t2/CustomCSSforFx#where-to-find-firefox-profile-folder-the-correct-location-for-user-styles)
  - `about:support` > `Profile Folder` > `Open Folder` or `about:profiles` > `Root Directory` > `Open Folder`
  - User styles belong into `<profile_folder>\chrome\` folder

- [Inspect ui or web content](https://github.com/Aris-t2/CustomCSSforFx)
  - Enable once
    - `Tools` > `WebDeveloper` > `Toggle Tools` > `'Customize Tools and get help button'` > `Settings` > `Enable browser chrome and add-on debugging toolboxes`
    - `Tools` > `WebDeveloper` > `Toggle Tools` > `'Customize Tools and get help button'` > `Settings` > `Enable remote debugging`
    - Hit <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Shift</kbd>+<kbd>I</kbd> or open `Tools` > `WebDeveloper` > `Browser Toolbox`

#### remove blue line for active tab
- [How to hide or change the color of the blue line over the tab?](https://support.mozilla.org/en-US/questions/1189959)
  ```css
  /* Hide blue stripe on active tab */
  .tab-line[selected="true"] {
    opacity: 0 !important;
  }
  ```

- [take out blue on top of tab](https://support.mozilla.org/en-US/questions/1290337)
  ```css
  .tab-line { display: none !important; }
  ```

- [is there any way to disable the blue line on top of the currently selected tab?](https://www.reddit.com/r/firefox/comments/7745x4/is_there_any_way_to_disable_the_blue_line_on_top/)
  ```css
  #TabsToolbar .tabbrowser-tab[selected] .tab-line {
      display: none !important;
  }
  ```
  or
  ```css
  #TabsToolbar .tabbrowser-tab .tab-line {
      display: none !important;
  }
  ```
- [[help] The blue line on top of active tab is back in Firefox 60](https://www.reddit.com/r/FirefoxCSS/comments/8hrpaf/help_the_blue_line_on_top_of_active_tab_is_back/)
  ```css
  #tabbrowser-tabs {
    --tab-line-color: var(--lwt-accent-color) !important;
  }
  ```

- [Change active tab line color in Tree Style Tabs?](https://www.reddit.com/r/FirefoxCSS/comments/hsiztn/change_active_tab_line_color_in_tree_style_tabs/)
  ```css
  :root .tab .highlighter::before {
    <do something>
  }
  ```
- [How to remove the thin blue bar on top of active tabs?](http://forums.mozillazine.org/viewtopic.php?f=38&t=3035591)
  ```css
  .tab-line {
      background-color:#f5f6f7 !important;
  }
  ```
  or
  ```css
  .tabbrowser-tab:not([selected="true"]):hover .tab-line {
     background-color: #cccdcf !important;
  }
  ```
- [[SOLVED] How to change active tab background color in css?](http://forums.mozillazine.org/viewtopic.php?f=38&t=3048845)
  ```css
  #main-window[lwthemetextcolor=bright] tab[selected="true"] {
    color: blue !important;
  }
  #main-window[lwthemetextcolor=bright] tab[selected="true"] .tab-background {
    background-color: gold !important;
    background-image: none !important;
  }
  ```
  or
  ```css
  /* ACTIVE TAB BACKGROUND COLOR */

  .tab-content[selected="true"] {
    background: rgba(65, 85, 145, 0.4) !important;
  }
  ```

## chrome
### shortcut

>[!TIP]
> references:
> - [Keyboard shortcut to pull Google Chrome tab into its own window](https://superuser.com/a/745584/112396)
> - [duplicate tab in same window](https://superuser.com/a/1501694/112396)

- <kbd>shift</kbd> + <kbd>w</kbd> : move tab to new windows by using Vimium
- <kbd>cmd</kbd>+<kbd>l</kbd> -> <kbd>shift</kbd>+<kbd>enter</kbd> : duplicate tab to new window
- <kbd>cmd</kbd>+<kbd>l</kbd> -> <kbd>opt</kbd>+<kbd>enter</kbd> : duplicate tab to same window

### download

> [!NOTE]
> references:
> - [Google Chrome Older Versions Download](https://www.slimjet.com/chrome/google-chrome-old-version.php)
> - [How to Download and Install Google Chrome On Mac OS](https://www.youtube.com/watch?v=BhmmLG_ZvGI)

- download standalone version via : https://www.google.com/chrome/?standalone=1
- download for OSX : https://www.google.com/chrome/?platform=mac
  - standalone for OSX : https://www.google.com/chrome/?platform=mac&standalone=1
- download for linux : https://www.google.com/chrome/?platform=linux
  - standalone for linux : https://www.google.com/chrome/?platform=linux&standalone=1

### tips
#### remove "All Bookmarks"

> [!NOTE|label:references:]
> - [How to remove "All Bookmarks" (Alle Lesezeichen) ?](https://www.reddit.com/r/chrome/comments/16mjav0/comment/k18pkqm/?utm_source=share&utm_medium=web2x&context=3)
> - [How do I get rid of the "All Bookmarks" tab?](https://www.reddit.com/r/chrome/comments/16mst9c/comment/k1a6hpf/?utm_source=share&utm_medium=web2x&context=3)

- open `about://flags`
- disable `Power bookmarks side panel`

#### restart
- `chrome://restart`

## chromium
- download page : https://download-chromium.appspot.com
- download for OSX : https://download-chromium.appspot.com/?platform=Mac&type=snapshots
