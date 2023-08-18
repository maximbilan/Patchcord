# Patchcord

The app tests your Internet connection and shows your Internet speed/ping/network data/etc. No ads, no tracking. The app uses [MLab](https://www.measurementlab.net/) servers.
The project represents an example of Redux architecture using SwiftUI + Combine + CoreData.

![Alt text](/img/1.png)

## Screenshots

![Alt text](/img/2.png)

## Issues

- Runtime warning `This method should not be called on the main thread as it may lead to UI unresponsiveness.`. It's coming from `NDT7` dependency. `WebSocket` uses `pthread` library.
