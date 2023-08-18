# Patchcord

The app tests your internet connection and shows your network data. No ads, no tracking. The app uses [MLab](https://www.measurementlab.net/) servers.
The project built with SwiftUI + Combine using Redux pattern. 

## Screenshots

![alt tag](https://raw.github.com/maximbilan/Patchcord/master/screenshots/1.png)
![alt tag](https://raw.github.com/maximbilan/Patchcord/master/screenshots/2.png)
![alt tag](https://raw.github.com/maximbilan/Patchcord/master/screenshots/3.png)

## Issues

- Runtime warning `This method should not be called on the main thread as it may lead to UI unresponsiveness.`. It's coming from `NDT7` dependency. `WebSocket` uses `pthread` library.
