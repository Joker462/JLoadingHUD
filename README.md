# JLoadingHUD
=======================


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

## License

The MIT License (MIT)

Copyright (c) 2019 Hung Thai [Joker](hungthai270893@gmail.com)
