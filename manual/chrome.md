# Google Chrome

* [Download](https://www.google.com/chrome/) and install
* Run script to configure default profile
    ```bash
    chrome-autoconfig
    ```

## Install Extensions

### [uBlock Origin](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm)
* Settings:
    * _I am an advanced user_
    * _Prevent WebRTC from leaking local IP addresses_
    * _Disable JavaScript_
* Filter Lists:
    * _Update Now_
    *  _POL_ +
        * _Polskie Filtry Prywatności (Privacy)_
        * _Polskie Filtry Elementów Irytujących (Annoyance)_
        * _Polskie Filtry Społecznościowe (Social)_
        * _AlleBlock_
        * _KAD - Przekręty_
* My rules:
    ```
    * * 1p-script block
    * * 3p-frame block
    * * 3p-script block
    * * inline-script block
    ```
    * _Save_
    * _Commit_

### [Cookie Autodelete](https://chrome.google.com/webstore/detail/cookie-autodelete/fhcgjolkccmbidfldomjliifgaodjagh?hl=en)
* Settings:
    * _Enable Automatic Cleaning_
    * **Disable:** _Show Notification_

### [HTTPS Everywhere](https://chrome.google.com/webstore/detail/https-everywhere/gcbommkclmclpchllfjekcdonpmejbdp)
* _Encrypt All Sites Eligible (EASE)_
 
### Remove built-in [Chrome Extensions](chrome://extensions/)
* Google Docs Offline
* Google Apps: Docs, Sheets, Slides, etc

## Swich to Chrome

Close all pages in Safari, clear history, switch to Chrome.

## Separate profiles

It's best to setup separate profiles for separate purposes.

After creating a profile, run `macos-bootstrap/scripts/chrome_profile.sh ProfileDirName` to setup another profile with the same configuration as default profile. 

