# Simple Build Guide

## Status

**Firewall:** On

**Updates:** Off

**ICMP:** On

**IPV6:** Off

**AV/Security:** Off

## Overview

**Operating System:** `Ubuntu 20.04 LTS`

**Hostname:** `simple`

**Vulnerability 1:** `GetSimple CMS v3.3.16 - Remote Code Execution (RCE)` `CVE-2022-41544`

**Vulnerability 2:** `None`

**Low priv Username:** `simple`

**Low priv Password:**  `simple1`

**Administrator Username:** `root`

**Administrator Password:** `ImNotThatSimple11`

**local.txt location:** `/home/simple/local.txt`

**local.txt contents:** `22f22750c3690cdf42b7d3b782d56de5`

**proof.txt location:** `/root/proof.txt`

**proof.txt contents:** `18af77e44d288b89923d03e1a189c249`

## Requirements

**CPU:** 2 CPU

**Memory:** 2 GB

**Space:** 10 GB

## Build

1. Install Ubuntu 20.04 LTS
2. Enable network connectivity
3. Upload the following files to `/root`
    - `build.sh`
4. Run `build.sh` as `root`
5. Visit http://targetip/admin and fill in the details

![](https://i.imgur.com/RGwQ6hB.png)

6. Click "Install Now!"

![](https://i.imgur.com/sdFTaGA.png)

7. Click "Login here" and change your password to `simple1`

![](https://i.imgur.com/BHULkLO.png)

8. "Save Settings"
9. Power Off The VM and take a snapshot.