//
//  UIView+.swift
//  [OJT]FinalChallenge
//
//  Created by 구지연 on 11/25/24.
//

import UIKit

extension UIView {
    func image(with color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
