# Patchcord

The app tests your internet connection and shows your Internet speed/ping/network data/etc. No ads, no tracking. The app uses [MLab](https://www.measurementlab.net/) servers.
The project was built with SwiftUI + Combine using the Redux pattern. 

## Screenshots

![Alt text](/screenshots/1.png)
![Alt text](/screenshots/2.png)
![Alt text](/screenshots/3.png)

## Issues

- Runtime warning `This method should not be called on the main thread as it may lead to UI unresponsiveness.`. It's coming from `NDT7` dependency. `WebSocket` uses `pthread` library.
