#  THStorytellingView

![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)
![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)
[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-%23FB613C.svg)](https://developer.apple.com/swift/)
<a href="https://developer.apple.com/xcode">
  <img src="https://img.shields.io/badge/Xcode-9-blue.svg"
      alt="Xcode">
</a>

This is the sample application for [THTiledImageView](https://github.com/TileImageTeamiOS/THTiledImageView.git), [THContentMarkerView](https://github.com/TileImageTeamiOS/THContentMarkerView),
 [THScrollView-minimap](https://github.com/TileImageTeamiOS/THScrollView-minimap.git) modules. You can see the feature of those libraries in this sample app.


## Feature
- [x] High Quality images(8K, 12K or more) are downloaded and rendered asynchronously using [THTiledImageView](https://github.com/TileImageTeamiOS/THTiledImageView.git).
- [x] Every markers in UIScrollView added using [THContentMarkerView](https://github.com/TileImageTeamiOS/THContentMarkerView). You can add markers on UIScrollView with contents by using THContentMarkerView.
- [x] We set various examples of marker contents. Don't hesitate to see it. 🧐
- [x][THScrollView-minimap](https://github.com/TileImageTeamiOS/THScrollView-minimap.git) let you know where you zoom in, when you zoom deep inside of UIScrollView.
- [x] In this app, we use [Firebase](https://firebase.google.com) for backend support.
- [x] Pure Swift 4.0

## Demo

### Pick Marker
![markerPick](images/markerPick.gif)

### Video
![video](images/video.gif)

### Audio
![audio](images/audio.gif)

### Text And Link
![textAndLink](images/textAndLink.gif)

### Add Marker

![addMarker](images/markerAdd.gif)

### Remove Marker

![removeMarker](images/removeMarker.gif)


## Installation

### CocoaPods

You can install the latest release version of CocoaPods with the following command

```bash
$ gem install cocoapods
```

We already set `Podfile` for this app. So, just run the following command:

```bash
$ pod setup
$ pod install
```

## Requirements

`THStorytellingView` is written in Swift 4, and compatible with iOS 9.0+



## Contributing

Please look over these things first.
- Please read our [Code of Conduct](https://github.com/MessageKit/MessageKit/blob/master/Code_of_Conduct.md)
- Download the project and check out the current code base. Suggest any improvements by opening a new issue.
- Please install [SwiftLint](https://github.com/realm/SwiftLint) to keep our conventions.



## Contributing

Please look over these things first.
- Please read our [Code of Conduct](https://github.com/MessageKit/MessageKit/blob/master/Code_of_Conduct.md)
- Check the [Contributing Guide Lines](https://github.com/MessageKit/MessageKit/blob/master/CONTRIBUTING.md).
- Download the project and check out the current code base. Suggest any improvements by opening a new issue.
- Check out the [current issues](https://github.com/MessageKit/MessageKit/issues) and see if you can tackle any of those.
- Check out the [What's Next](#whats-next) section :point_down: to see where we are headed.
- Please install [SwiftLint](https://github.com/realm/SwiftLint) to keep our conventions.



## What's Next?

Check out the [Releases](https://github.com/MessageKit/MessageKit/releases) to see what we are working on next.
