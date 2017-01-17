## Methods for Indoor positioning:
- Least squares
- Lateration: method for estimating the position of the device given the distance measurements. Non accurate as distance measure are usually noisy.
- Hyperbolic lateration: instead of distance, difference of distances is available.
- Angulation: angle between router1-device and device-router2. 
- Proximity detection
- Fingerprinting: missing data can be estimated using methods like EM(rather than simple mean estimation: source Quora). k-NN can be used. It performs the weighted sum of the k-neighbours' RSS values in the reference map. Weighted sum because some positions might be more reliable based surroundings and how accurate the measurements are(signal attenuation from furniture, signal scattering and signal reflection) 

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
- Non parametric method but with parametric mean and covariance function. If there is enough evidence avialable(measurements), the model will override the avialable 

## Application:
- BLE beacons RSS values in addition to proximity motion detector data, Active ahead predictive data (Active+ data, if lights are dim then it is less likely that someone is around) can improve the accuracy of the position.
- So need to create a solution which doesn't need creating of radio map even with slight change in the position of things inside a room, if incase fingerprinting is used.
