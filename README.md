# Indoor Positioning

### A simple fingerprinting-based localization project:

- Setting up the beacons in a corridor of size 30m x 2.35m. 
- Creating the reference map by getting the RSS at predefined locations. Here, we took 20 measurements.
- An interpolating observation model was developed.
- A quasi-constant dynamic model was added.
- A particle filter was built for the same.
- Results were evaluated.

### Other details:
- Beacons used were from kontact.io.
- Product link: https://store.kontakt.io/our-products/27-beacon.html
- Measurements app: Indoor Atlas proprietary app *SenseServe*.
- Mobile platform: Android 6.0.1
- Mobile device: Nexus 6P

# Observations from Literature review:
### Locating User Equipments and Access Points using RSSI Fingerprints: A Gaussian Process Approach. Yiu et al.

- **Drawback of fingerprinting** is that radiomap has to be computed when the circumstances change. This includes change in location of beacons (BLE or WiFi), restructuring of the of the indoor space. 

- If certain MAC is not heard during some measurement it is put to minimum power device sensitivity level, here our BLE beacon has `-93 dB` as sensitivity level and wifi are assumed to have `-110 dB`. Even the test data is replaced with the same constants.

### Wi-Fi Fingerprint-Based Indoor Positioning: Recent Advances and Comparisons. He et al.

- RSS can induce measurement noise, for example, multi-path effects.

- **Usage of temporal and spatial signal patterns**: in order to mitigate the error due to signal fluctuation, one method is to use the correlation between Wi-Fi signals and observable data like walking trajectory, indoor building structure and AP locations

- **Collaborative Localization** - using other bluetooth or sound to get the relative location with the neighbours.

- **Motion assisted localization** - using the sensors present the device.

- Deterministic and Probablistic methods are employed for localization. 
      - Deterministic Algorithms (DA) use similarity metric like Euclidean distance, cosine similarity or Tanimato similarity for signal comparison.
      - DA are used as they are easy to implement. e.g., k-NN 
      - SVM and LDA give better localization accuracy with higher computational cost.
      - Probabilistic algorithms (PA) use statistical inference, e.g., maximum likelihood, KL divergence, EM, GP.
      - One advantage is that we get uncertainty of estimates using these methods.
      
### Revisiting Gaussian Process Regression Modeling for Localization in Wireless Sensor Networks.

- Fingerprinting values must be taken in the same location with out a human, risk of signal attenuation. If human is recording the measurements, then measurements must be taken in four different directions and average them.
