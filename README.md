#  THStorytellingView

![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)
![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)
[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-%23FB613C.svg)](https://developer.apple.com/swift/)

This is the sample application for [THTiledImageView](https://github.com/TileImageTeamiOS/THTiledImageView.git), [THContentMarkerView](https://github.com/TileImageTeamiOS/THContentMarkerView),
 [THScrollView-minimap](https://github.com/TileImageTeamiOS/THScrollView-minimap.git) modules. You can see the feature of those libraries in this sample app.


## Feature
- [x] High Quality images(8K, 12k or more) are downloaded and rendered asynchronously using [THTiledImageView](https://github.com/TileImageTeamiOS/THTiledImageView.git).
- [x] Every markers in UIScrollView added using [THContentMarkerView](https://github.com/TileImageTeamiOS/THContentMarkerView). You can add markers on UIScrollView with contents by using THContentMarkerView.
- [x][THScrollView-minimap](https://github.com/TileImageTeamiOS/THScrollView-minimap.git) let you know where you zoom in, when you zoom deep inside of UIScrollView.

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
