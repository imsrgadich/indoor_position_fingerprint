# Indoor Positioning

### A simple fingerprinting-based localization project:

- Setting up the beacons in a corridor of size 30m x 2.35m. 
- Creating the reference map by getting the RSS at predefined locations. Here, we took 20 measurements.
- An interpolating observation model was developed.
- A quasi-constant dynamic model was added.
- A particle filter was built for the same.
- Results were evaluated.

Beacons used were from kontact.io

Product link: https://store.kontakt.io/our-products/27-beacon.html

Measurements app: Indoor Atlas proprietary app *SenseServe*

Mobile platform: Android 6.0.1

Mobile device: Nexus 6P

# Observations from Literature review:
- *Drawback of fingerprinting* is that radiomap has to be computed when the circumstances change. This includes change in location of beacons (BLE or WiFi), restructuring of the of the indoor space. 

- If certain MAC is not heard during some measurement it is put to minimum power device sensitivity level, here our beacon

