//
//  UIView+.swift
//  uipip
//
//  Created by Akihiro Urushihara on 2021/11/27.
//  @see https://iganin.hatenablog.com/entry/2020/05/11/070950
//

import UIKit

extension UIView {

    var uiImage: UIImage {
        let imageRenderer = UIGraphicsImageRenderer.init(size: bounds.size)
        return imageRenderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
}
