//
//  ViewController.swift
//  uipip
//
//  Created by Akihiro Urushihara on 2021/11/27.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {

  private let _pipContent = VideoProvider()
  private var _pipController: AVPictureInPictureController?
  private let _bufferDisplayLayer = AVSampleBufferDisplayLayer()
  private var _pipPossibleObservation: NSKeyValueObservation?
  private let _startButton = UIButton()

  override func viewDidLoad() {
    super.viewDidLoad()
    let session = AVAudioSession.sharedInstance()
    try! session.setCategory(.playback, mode: .moviePlayback)
    try! session.setActive(true)

    let margin = ((view.bounds.width - 200) / 2)
    _startButton.frame = .init(x: margin, y: 80, width: 200, height: 30)
    _startButton.addTarget(self, action: #selector(ViewController.toggle), for: .touchUpInside)
    _startButton.setTitle("Start PiP", for: .normal)
    self.view.addSubview(_startButton)

    // 表示用の画面を作成
    let videoContainerView = UIView()
    videoContainerView.frame = .init(x: margin, y: 200, width: 200, height: 30)
    self.view.addSubview(videoContainerView)

    let bufferDisplayLayer = _pipContent.bufferDisplayLayer
    bufferDisplayLayer.frame = videoContainerView.bounds
    bufferDisplayLayer.videoGravity = .resizeAspect
    videoContainerView.layer.addSublayer(bufferDisplayLayer)

    _pipContent.start()

    DispatchQueue.main.async {
      self.start()
    }
  }

  func start() {

    // PinP をサポートしているデバイスかどうかを確認
    if AVPictureInPictureController.isPictureInPictureSupported() {

      // AVPictureInPictureController の生成
      _pipController = AVPictureInPictureController(
        contentSource: .init(
          sampleBufferDisplayLayer:
            _pipContent.bufferDisplayLayer,
          playbackDelegate: self))
      _pipController?.delegate = self

      _pipPossibleObservation = _pipController?.observe(
        \AVPictureInPictureController.isPictureInPicturePossible,
        options: [.initial, .new]) { [weak self] _, change in
        guard let self = self else { return }

        // 再生可能になったら PinP ボタンを有効化
        if (change.newValue ?? false) {
          self._startButton.isEnabled = (change.newValue ?? false)
        }
      }
    }
  }


  @objc func toggle() {
    guard let _pipController = _pipController else { return }
    if !_pipController.isPictureInPictureActive {
      _pipController.startPictureInPicture()
    } else {
      _pipController.stopPictureInPicture()
    }
  }
}


extension ViewController: AVPictureInPictureControllerDelegate {

  func pictureInPictureController(
    _ pictureInPictureController: AVPictureInPictureController,
    failedToStartPictureInPictureWithError error: Error
  ) {
    print("\(#function)")
    print("pip error: \(error)")
  }

  func pictureInPictureControllerWillStartPictureInPicture(
    _ pictureInPictureController: AVPictureInPictureController
  ) {
    print("\(#function)")
  }

  func pictureInPictureControllerWillStopPictureInPicture(
    _ pictureInPictureController: AVPictureInPictureController
  ) {
    print("\(#function)")
  }
}

extension ViewController: AVPictureInPictureSampleBufferPlaybackDelegate {

  func pictureInPictureController(
    _ pictureInPictureController: AVPictureInPictureController,
    setPlaying playing: Bool
  ) {
    print("\(#function)")
  }

  func pictureInPictureControllerTimeRangeForPlayback(
    _ pictureInPictureController: AVPictureInPictureController
  ) -> CMTimeRange {
    print("\(#function)")
    return CMTimeRange(start: .negativeInfinity, duration: .positiveInfinity)
  }

  func pictureInPictureControllerIsPlaybackPaused(
    _ pictureInPictureController: AVPictureInPictureController
  ) -> Bool {
    print("\(#function)")
    return false
  }

  func pictureInPictureController(
    _ pictureInPictureController: AVPictureInPictureController,
    didTransitionToRenderSize newRenderSize: CMVideoDimensions
  ) {
    print("\(#function)")
  }

  func pictureInPictureController(
    _ pictureInPictureController: AVPictureInPictureController,
    skipByInterval skipInterval: CMTime,
    completion completionHandler: @escaping () -> Void
  ) {
    print("\(#function)")
    completionHandler()
  }
}
