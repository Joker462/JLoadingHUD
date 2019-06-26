# JLoadingHUD


## Introduction
`JLoadingHUD` is a clean and easy-to-use HUD meant to display the progress of an ongoing task on iOS.


## Demo
![alt_tag](https://github.com/Joker462/JLoadingHUD/blob/master/demo.gif)

## Installation

### Cocoapods

Add `JLoadingHUD` in your `Podfile`.

```ruby
use_frameworks!

pod 'JLoadingHUD'
```

Then, run the following command.
```bash
$ pod install
```

### Manual

Copy `JLoadingHUD` folder to your project. That's it.

## Usage

Firstly, import `JLoadingHUD`

```swift
import JLoadingHUD
```

### Control

Show loading

```swift
JLoadingHUD.shared.show()
```

Hide loading

```swift
JLoadingHUD.shared.hide()
```

### Customization

`JLoadingHUD` can be customized via the following methods:

> BACKGROUND <

Change background color

```swift
JLoadingHUD.shared.backgroundViewColor = UIColor.clear
```
> LOADING VIEW <

```swift
JLoadingHUD.shared.loadingViewBackgroundColor = UIColor.red           // Change loading view background color
JLoadingHUD.shared.loadingViewSize = 128.0                            // Change loading view size
JLoadingHUD.shared.loadingViewCornerRadius = 16.0                     // Change loading view corner radius
```
> LOADING PROGRESS VIEW <

```swift
JLoadingHUD.shared.loadingStrokeWidth = 4.0                           // Change loading progress size
JLoadingHUD.shared.loadingStrokeColor = UIColor.white                 // Change loading progress color
```
Types:

`gradientCircle` `circleSpin` `circleSemi` `circleScaleRipple` `ballPulse` `ballPulseQueue` `ballPulseRipple` `ballPulseOpacityRipple` `ballPulseSync`

```swift
JLoadingHUD.shared.progressLayerType = .circleSpin
```

## License

The MIT License (MIT)

Copyright (c) 2019 Hung Thai (hungthai270893@gmail.com)
