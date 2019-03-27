# Little Snitch

[Download](https://www.obdev.at/products/littlesnitch/download.html) and check integrity before installing.

```bash
codesign -v --verify -R="anchor apple generic and certificate leaf[subject.OU] = MLZF7K7B5R" ~/Downloads/LittleSnitch*.dmg
```

Install. Restart will be required.
* Configure in Alert mode

**Preferences:**

* Alert
    * Preselected options:
        * Duration: _15 minutes_
        * Port and protocol: _Specific_
    * **Disable:** _Confirm with Return and Escape_
    * Detail Level: _Show Port and Protocol Details_
* Monitor
    * _Show data rates as numerical values_
    * _Show Helper XPC Processes_
* Security
    * _Allow global rule editing*
    * **Disable:** _Respect privacy of other users_ 
    * **Disable:** _Ignore code signature for local network connections_
* Advanced
    * _Mark new rules as unapproved_
    * **Disable:** _Approve rules automatically_
    
**Rules:**

* Subscribe to rule groups (all or selected, remember to set them as _Active_ and uncheck _Disable new allow rules_):

    * **[Basic](https://raw.githubusercontent.com/themand/macos-bootstrap/master/lsrules/Basic.lsrules):** basic networking rules to allow computer connect to network using DHCP, allow DNS queries, allow Little Snitch updates and helper.
    * **[macOS](https://raw.githubusercontent.com/themand/macos-bootstrap/master/lsrules/macOS.lsrules):** required for macOS and iCloud services.
    * **[Restricted Networking](https://raw.githubusercontent.com/themand/macos-bootstrap/master/lsrules/Restricted%20Networking.lsrules):** Disables NetBIOS, Multicast DNS (Bonjour), etc. Recommended to use if you don't need this features all the time and disable ruleset when you need to use them. 
    * **[Google Chrome](https://raw.githubusercontent.com/themand/macos-bootstrap/master/lsrules/Google%20Chrome.lsrules)**
    * **[Webstorm](https://raw.githubusercontent.com/themand/macos-bootstrap/master/lsrules/Webstorm.lsrules)**
    
* Factory Rules: **Disable** all factory rules
* If enabled, disable subscriptions to both rule groups as well as individual rules inside groups (they might be active even if subscription is inactive) 
    * iCloud Services
    * macOS Services
