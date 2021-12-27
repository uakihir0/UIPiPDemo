**This demo app is now available as a Cocoapods library.**  
Please refer to **[UIPiPView](https://github.com/uakihir0/UIPiPView).**

---

[> 日本語](./README_ja.md)

# UIPiPDemo

This is a demo app for displaying an arbitrary `UIView` in iOS using picture-in-picture. It can be used to display information that changes in real time (e.g. stock prices) in a PiP so that you can check it while other apps are running. I hope you'll use this sample to implement some interesting ideas!

<img src="sample.gif">

## How to use

Load it in Xcode and run the build for **ACTUAL DEVICES**. Launch the app and start `Start PiP` to play the video showing the current time in PiP. The video will continue to play even if the app is put back in the background.

## Implementation

A new `AVPictureInPictureController.ContentSource` has been added since iOS15. [(Official Link)](https://developer.apple.com/documentation/avkit/avpictureinpicturecontroller/contentsource) This allows you to use the PiP video source This allows us to handle `AVSampleBufferDisplayLayer` as a PiP video source, and also provides a callback function, which greatly expands the range of things we can express with PiP. For example, `UIView`, which is the basic `View` class when written in `UIKit`, can now be easily displayed in PiP almost as is.

In this sample repository, `UIView` is converted to `UIImage`, then to `CMSampleBuffer`, and then to `AVSampleBufferDisplayLayer` by `enque`. In this repository, the current time is displayed for `UILabel`.

## Class structure

- [VideoProvider.swift](https://github.com/uakihir0/UIPiPDemo/blob/main/uipip/VideoProvider.swift)
  - A class that holds an `AVSampleBufferDisplayLayer` and provides a video.
  - This class is used to convert the `UILabel` into a video source.
- [ViewController.swift](https://github.com/uakihir0/UIPiPDemo/blob/main/uipip/ViewController.swift)
  - Class that holds the start button for PiP and `AVSampleBufferDisplayLayer` with `addSubview`.
  - This class implements PiP by following the [documentation](https://developer.apple.com/documentation/avkit/adopting_picture_in_picture_in_a_custom_player) of the official page almost directly. PiP implementation.

## Notes.

I don't know much about `AVKit` and `AVFoundation`, so this may be a useless implementation. In particular, the conversion from `UIImage` to `CMSampleBuffer` is done once via `Data (jpeg)`, so I would be very happy if you could optimize that.

If there's a positive response, I'm thinking of providing a library like `PiPView` that inherits from `UIView`, that can also be used as a `UIView`, and when you hit the API, it will PiP the contents.

Since the contents of the `UIView` will be displayed when you `enque` the `AVSampleBufferDisplayLayer`, you will need to `enque` it periodically, and the drawing cost will be quite large. Be careful when performing animation. In this repository, drawing is performed every 0.3 seconds.

## Reference

- [Delivery Comment Bar - New PiP experience in iOS15](https://tech.mirrativ.stream/entry/2021/11/26/114002)
  - This is the article that motivated me to create this. Thanks for the great discovery.
- [bricklife/ImagePipDemo](https://github.com/bricklife/ImagePipDemo)
  - This is the repository where this idea was implemented when PiP was first released.
  - It was possible to implement this idea before iOS15 API was released.
- [jazzychad/PiPBugDemo](https://github.com/jazzychad/PiPBugDemo)
  - A repository that reports on PiP behavior on `tvOS` `macOS`.
  - This repository is playing multiple images in sequence with PiP.
  - I've used the implementation quite a bit as a reference.

## Author.

[Twitter: @uakihir0](https://twitter.com/uakihir0)

If you have any questions, please contact the above account or raise an issue.

## License

MIT
