# UIPiPDemo

これは iOS で任意の `UIView` をピクチャーインピクチャーを使って表示するデモアプリです。リアルタイムに変化する情報 (例えば株価など) を PiP で表示して、他アプリの起動中でも確認できるようにするなどの用途に使用することができます。このサンプルを使って面白いアイデアを実現してくれることを期待しています！

<img src="sample.gif">

## 使用方法

Xcode で読み込んで **実機向け** にビルドを実行します。アプリを起動して `Start PiP` を起動すると、現在時刻を表示する動画が PiP で再生されます。アプリをバックグラウンドに戻しても、再生が持続されます。

## 実装

iOS15 から新たに `AVPictureInPictureController.ContentSource` が追加されました。[(公式リンク)](https://developer.apple.com/documentation/avkit/avpictureinpicturecontroller/contentsource) これによって、PiP の動画ソースとして `AVSampleBufferDisplayLayer` も扱えるようになり、かつコールバック関数が用意され、非常に PiP で表現できることの幅が広がりました。例として、`UIKit` で書かれている場合の基本的な `View` のクラスである `UIView` についても、ほぼそのまま PiP で簡単に表示できるようになりました。

本サンプルレポジトリでは、`UIView` を `UIImage` に変換し、更に `CMSampleBuffer` に変換した上で、`AVSampleBufferDisplayLayer` に `enque` することで実現しています。本レポジトリでは現在時刻を表示している `UILabel` を対象に表示しています。

## クラス構成

- [VideoProvider.swift](https://github.com/uakihir0/UIPiPDemo/blob/main/uipip/VideoProvider.swift)
  - `AVSampleBufferDisplayLayer` を保持して動画を提供するクラス。
  - このクラスで `UILabel` を動画ソースに変換しています。
- [ViewController.swift](https://github.com/uakihir0/UIPiPDemo/blob/main/uipip/ViewController.swift)
  - PiP の開始ボタンや、`AVSampleBufferDisplayLayer` を `addSubview` しているクラス。
  - 公式ページの[ドキュメント](https://developer.apple.com/documentation/avkit/adopting_picture_in_picture_in_a_custom_player)ほぼそのまま踏襲して PiP の実装しています。

## 注意事項

`AVKit`, `AVFoundation` 関連の実装はあまり知識がないので、もしかしたら無駄な実装になっている可能性があります。特に `UIImage` から `CMSampleBuffer` への変換は一旦 `Data (jpeg)` を経由して行っているので、そこを最適化していただければとても嬉しいです。

もし反響があれば、`UIView` を継承した `PiPView` のような、`UIView` としても使えて、API を叩くと、その中身を PiP してくれるようなライブラリを提供しようと考えています。

`AVSampleBufferDisplayLayer` に `enque` したら `UIView` の内容が表示されるため、定期的に `enque` する必要があり、その描画コストはそれなりに大きいです。アニメーションなどを行う場合には注意してください。本レポジトリでは 0.3 秒毎に描画を行っています。

## 参考

- [配信コメントバー 〜 iOS15 で実現する新しい PiP 体験](https://tech.mirrativ.stream/entry/2021/11/26/114002)
  - 作成の動機になった記事です。素晴らしい発見ありがとうございます。
- [bricklife/ImagePipDemo](https://github.com/bricklife/ImagePipDemo)
  - PiP が出た当初に本アイデアを実現されていたレポジトリ。
  - iOS15 の API が出る以前から実現自体は可能でした。
- [jazzychad/PiPBugDemo](https://github.com/jazzychad/PiPBugDemo)
  - `tvOS` `macOS` 上での PiP の挙動について報告しているレポジトリ。
  - このレポジトリは複数の画像を PiP で順に再生しています。
  - かなり実装を参考にさせてもらいました。

## 作者

[Twitter: @uakihir0](https://twitter.com/uakihir0)

質問等があれば上記アカウントに連絡するか issue を立ててください。

## ライセンス

MIT
