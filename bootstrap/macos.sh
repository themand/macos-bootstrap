#!/usr/bin/env bash

set -euo pipefail
. ${0%/*}/../includes/functions.sh

H1 "macOS configuration"
sudo -v

H2 "Updating macOS. If this requires restart, run the script again"
sudo -v
sudo softwareupdate -ia

H2 "Configuring automatic software update"
H3 "Enabling the automatic update check"
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool true
H3 "Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
H3 "Download newly available updates in background"
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool true
H3 "Auto install System data files & security updates"
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticallyInstallMacOSUpdates -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist ConfigDataInstall -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall -bool true
H3 "Allow the App Store to reboot machine on macOS updates"
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true
H3 "Auto update App Store applications"
sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true

H2 "Installing Xcode Command Line Tools"
if ! $(xcode-select -p &>/dev/null); then
    xcode-select --install &>/dev/null
    sleep 1
    until $(xcode-select -p &>/dev/null); do sleep 5; done
else
    H3 "Already installed"
fi

H2 "Quitting System Preferences app if running to prevent overriding changes"
osascript -e 'tell application "System Preferences" to quit'

H2 "Setting computer name"
CURRENT_NAME=`scutil --get ComputerName`
readlndef `openssl rand -hex 6` "Enter computer name (enter to leave randomly generated, space to keep current: $CURRENT_NAME)"
if [[ "$REPLY" = " " ]]; then
    REPLY="$CURRENT_NAME"
else
    sudo scutil --set ComputerName "$REPLY"
fi
readlndef "$REPLY" "Enter hostname"
sudo scutil --set HostName "$REPLY"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$REPLY"
readlndef "$REPLY" "Enter localhost name"
sudo scutil --set LocalHostName "$REPLY"

H2 "Standby, sleep and hibernation settings"
H3 "Configuring standby delays"
sudo pmset -a powernap 0
sudo pmset -a standby 0
sudo pmset -a standbydelay 0
sudo pmset -a autopoweroff 0
H3 "Forcing hibernation instead of sleep (with FileVault keys eviction)"
sudo pmset -a destroyfvkeyonstandby 1 >/dev/null
sudo pmset -a hibernatemode 25
H3 "Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
H3 "Sleep delay"
readlndef 5 "Enter number of idle minutes before sleep"
sudo systemsetup -setcomputersleep "$REPLY" >/dev/null
sudo systemsetup -setdisplaysleep "$REPLY" >/dev/null
sudo systemsetup -setharddisksleep "$REPLY" >/dev/null
sudo systemsetup -setwakeonnetworkaccess off >/dev/null
sudo systemsetup -setrestartfreeze off >/dev/null
sudo systemsetup -f -setremotelogin off >/dev/null
sudo systemsetup -setremoteappleevents off >/dev/null

H2 "Screenshots settings"
H3 "Set default screenshots location to ~/Screenshots"
mkdir -p "${HOME}/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"
H3 "Disable shadow in window screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

H2 "Interface"
yesno "dark mode (needs logging out to see change)?"
if $YESNO; then defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark";
else defaults delete NSGlobalDomain AppleInterfaceStyle; fi
H3 "Auto-hide dock"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-time-modifier -float 0.5
H3 "Don't auto-hide menu bar"
defaults write NSGlobalDomain _HIHideMenuBar -bool false
H3 "Setting YYYY-MM-DD date display"
defaults write NSGlobalDomain AppleICUDateFormatStrings -dict "1" "y-MM-dd" "2" "y-MM-dd"
H3 "Configuring menubar clock display"
defaults write com.apple.menuextra.clock DateFormat "EEE d MMM  HH:mm"
defaults write com.apple.menuextra.clock "FlashDateSeparators" -int 0
defaults write com.apple.menuextra.clock "IsAnalog" -int 0
H3 "Save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
H3 "Save panel always expanded"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
H3 "Print panel always expanded"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
H3 "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
H3 "Making ~/Library visible"
chflags nohidden ~/Library
H3 "Clearing default dock persistent apps list"
defaults write com.apple.dock persistent-apps -array
H3 "Speed up Mission Control animations"
defaults write com.apple.dock expose-animation-duration -float 0.1
H3 "Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true
H3 "Don’t show Dashboard as a Space"
defaults write com.apple.dock dashboard-in-overlay -bool true
H3 "Don’t automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false
H3 "Hot corner top-right: mission control"
defaults write com.apple.dock wvous-tr-corner -int 2
defaults write com.apple.dock wvous-tr-modifier -int 0
H3 "Hot corner top-left: application windows"
defaults write com.apple.dock wvous-tl-corner -int 3
defaults write com.apple.dock wvous-tl-modifier -int 0
H3 "Hot corner bottom-right: notification center"
defaults write com.apple.dock wvous-br-corner -int 12
defaults write com.apple.dock wvous-br-modifier -int 0
H3 "Hot corner bottom-left: desktop"
defaults write com.apple.dock wvous-bl-corner -int 4
defaults write com.apple.dock wvous-bl-modifier -int 0
H3 "Show battery percentage in menu bar"
defaults write com.apple.menuextra.battery ShowPercent "YES"
H3 "Disable sound effect at boot"
sudo nvram SystemAudioVolume=" "
H3 "Disable crash reporter"
defaults write com.apple.CrashReporter DialogType none

H2 "Input devices"
H3 "Trackpad tap to click"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
H3 "Fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 10

H2 "Finder configuration"
H3 "Disable window animations"
defaults write com.apple.finder DisableAllAnimations -bool true
H3 "Show icons for external hard drives, servers, and removable media on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
H3 "Show hidden files by default"
defaults write com.apple.finder AppleShowAllFiles -bool true
H3 "Show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
H3 "Show status bar"
defaults write com.apple.finder ShowStatusBar -bool true
H3 "Show path bar"
defaults write com.apple.finder ShowPathbar -bool true
H3 "Keep folders on top when sorting by name"
defaults write com.apple.finder _FXSortFoldersFirst -bool true
H3 "Avoid creating .DS_Store files on network or USB volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
H3 "Automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
H3 "Use list view in all Finder windows by default"
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`, `Nlsv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
H3 "Show item info near icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist || /usr/libexec/PlistBuddy -c "Add :FK_StandardViewSettings:IconViewSettings:showItemInfo bool true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
H3 "Setting grid spacing for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 50" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 50" ~/Library/Preferences/com.apple.finder.plist || /usr/libexec/PlistBuddy -c "Add :FK_StandardViewSettings:IconViewSettings:gridSpacing integer 50" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 50" ~/Library/Preferences/com.apple.finder.plist
H3 "Setting the size of icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist || /usr/libexec/PlistBuddy -c "Add :FK_StandardViewSettings:IconViewSettings:iconSize integer 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
H3 "Empty Trash securely by default"
defaults write com.apple.finder EmptyTrashSecurely -bool true
H3 "Set Default Finder Location to Home Folder"
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

H2 "Activity Monitor"
H3 "Show the main window when launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
H3 "Visualize CPU usage in the Activity Monitor Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5
H3 "Show all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0
H3 "Sort Activity Monitor results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

H2 "Safari & WebKit"
H3 "Privacy: don’t send search queries to Apple"
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true
H3 "Press Tab to highlight each item on a web page"
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true
H3 "Show the full URL in the address bar (note: this still hides the scheme)"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
H3 "Set Safari’s home page to about:blank"
defaults write com.apple.Safari HomePage -string "about:blank"
H3 "Prevent Safari from opening ‘safe’ files automatically after downloading"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
H3 "Allow hitting the Backspace key to go to the previous page in history"
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true
H3 "Hide Safari’s bookmarks bar by default"
defaults write com.apple.Safari ShowFavoritesBar -bool false
H3 "Hide Safari’s sidebar in Top Sites"
defaults write com.apple.Safari ShowSidebarInTopSites -bool false
H3 "Disable Safari’s thumbnail cache for History and Top Sites"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2
H3 "Enable Safari’s debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
H3 "Make Safari’s search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false
H3 "Enable the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
H3 "Add a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
H3 "Disable AutoFill"
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false
H3 "Warn about fraudulent websites"
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true
H3 "Disable plug-ins"
defaults write com.apple.Safari WebKitPluginsEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false
H3 "Disable Java"
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false
H3 "Block pop-up windows"
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false
H3 "Enable Do Not Track"
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

H2 "Spotlight"
H3 "Excluding searching for some items and sending search queries to Apple"
defaults write com.apple.spotlight orderedItems -array \
'{"enabled" = 1;"name" = "APPLICATIONS";}' \
'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
'{"enabled" = 1;"name" = "DIRECTORIES";}' \
'{"enabled" = 1;"name" = "PDF";}' \
'{"enabled" = 1;"name" = "DOCUMENTS";}' \
'{"enabled" = 1;"name" = "PRESENTATIONS";}' \
'{"enabled" = 1;"name" = "SPREADSHEETS";}' \
'{"enabled" = 1;"name" = "MESSAGES";}' \
'{"enabled" = 1;"name" = "CONTACT";}' \
'{"enabled" = 1;"name" = "EVENT_TODO";}' \
'{"enabled" = 0;"name" = "IMAGES";}' \
'{"enabled" = 1;"name" = "MUSIC";}' \
'{"enabled" = 1;"name" = "MOVIES";}' \
'{"enabled" = 0;"name" = "FONTS";}' \
'{"enabled" = 0;"name" = "BOOKMARKS";}' \
'{"enabled" = 0;"name" = "SOURCE";}' \
'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
'{"enabled" = 0;"name" = "MENU_OTHER";}' \
'{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
'{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
'{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
defaults write com.apple.lookup.shared LookupSuggestionsDisabled -int 1
H3 "Reloading settings"
sudo killall mds
H3 "Rebuilding the index from scratch"
sudo mdutil -i off /
sudo rm -rf /.Spotlight-V100/
sudo mdutil -i on /

H2 "Terminal.app"
H3 "Only use UTF-8 in Terminal.app"
defaults write com.apple.terminal StringEncodings -array 4
H3 "Enable Secure Keyboard Entry in Terminal.app"
defaults write com.apple.terminal SecureKeyboardEntry -bool true

H2 "TextEdit"
H3 "Use plain text mode for new TextEdit documents"
defaults write com.apple.TextEdit RichText -int 0
H3 "Open and save files as UTF-8 in TextEdit"
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

H2 "Other privacy and security settings"
H3 "Privacy: Out put of Apple ad tracking"
defaults write com.apple.AdLib forceLimitAdTracking -bool true
defaults write com.apple.AdLib AD_DEVICE_IDFA -string '00000000-0000-0000-0000-000000000000'
killall adprivacyd
H3 "Security: Disable captive portal"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control.plist Active -bool false
H3 "Security/Privacy: Disable Bonjour multicast advertisements"
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool YES

H2 "Killing affected applications to restart them and reload config"
for app in "Activity Monitor" \
	"Address Book" \
	"Calendar" \
	"cfprefsd" \
	"Contacts" \
	"Dock" \
	"Finder" \
	"Mail" \
	"Messages" \
	"Photos" \
	"Safari" \
	"SystemUIServer" \
	"iCal"; do
	killall "${app}" &> /dev/null || true
done
H2WARN "Not killing Terminal.app - you need to restart it manually for changes to make effect"
H2WARN "Some of the changes require a logout/restart to make effect"
