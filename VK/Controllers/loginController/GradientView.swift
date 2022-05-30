//
//  GradientView.swift
//  VK
//
//  Created by Артур Кондратьев on 29.03.2022.
//

import UIKit

//@IBDesignable
class GradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }

    @IBInspectable var startColor: UIColor = .white {
        didSet {
            updateColors()
        }
    }

    @IBInspectable var endColor: UIColor = .black {
        didSet {
            updateColors()
        }
    }

    @IBInspectable var startLocation: CGFloat = 0 {
        didSet {
            updateLocations()
        }
    }

    @IBInspectable var endLocation: CGFloat = 1 {
        didSet {
            updateLocations()
        }
    }

    @IBInspectable var startPoint: CGPoint = .init(x: 1, y: 0) {
        didSet {
            updateStartPoint()
        }
    }

    @IBInspectable var endPoint: CGPoint = .init(x: 1, y: 0) {
        didSet {
            updateEndPoint()
        }
    }


    func updateLocations() {
        self.gradientLayer.locations = [self.startLocation as NSNumber, self.endLocation as NSNumber]
    }

    func updateColors() {
        self.gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
    }

    func updateStartPoint() {
        self.gradientLayer.startPoint = startPoint
    }

    func updateEndPoint() {
        self.gradientLayer.endPoint = endPoint
    }
}


