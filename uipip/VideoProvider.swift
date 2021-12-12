//
//  VideoProvider.swift
//  uipip
//
//  Created by Akihiro Urushihara on 2021/11/27.
//

import UIKit
import AVKit
import AVFoundation

class VideoProvider: NSObject {

    private var timer: Timer!
    var bufferDisplayLayer = AVSampleBufferDisplayLayer()

    // 適当に UILabel を描画
    private let _label: UILabel = {

        let label = UILabel()
        label.backgroundColor = .white
        label.frame = .init(x: 0, y: 0, width: 200, height: 30)
        label.font = .boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    // 現在時刻を表示
    func nextBuffer() -> UIImage {
        _label.text = "\(Date())"
        return _label.uiImage
    }

    func start() {
        let timerBlock: ((Timer) -> Void) = { [weak self] timer in
            guard let self = self else { return }
            if (self.bufferDisplayLayer.status == .failed) {
                self.bufferDisplayLayer.flush()
            }

            guard let buffer = self.nextBuffer().cmSampleBuffer else { return }
            self.bufferDisplayLayer.enqueue(buffer)
        }

        timer = Timer(timeInterval: 0.3, repeats: true, block: timerBlock)
        RunLoop.main.add(timer, forMode: .default)
    }

    func stop() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }

    func isRunning() -> Bool {
        return timer != nil
    }
}
