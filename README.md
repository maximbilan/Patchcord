# Patchcord

The app that tests your internet connection and show your network data. No ads, no tracking. The app uses [MLab](https://www.measurementlab.net/) servers.
The project built with SwiftUI + Combine using Redux pattern. 

## Roadmap

- Distribution
- UI
- Snapshot testing
- UI tests
- Docs

## Issues

- Runtime warning `This method should not be called on the main thread as it may lead to UI unresponsiveness.`. It's coming from `NDT7` dependency. `WebSocket` uses `pthread` library.
