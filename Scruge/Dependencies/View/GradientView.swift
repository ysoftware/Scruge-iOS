//
//  GradientView.swift
//  LigaStavok
//
//  Created by Sergey Sergeyev on 4/4/18.
//  Copyright © 2018 MobSolutions. All rights reserved.
//

import UIKit

@IBDesignable
final class GradientView: UIView {
    
    // MARK: - Публичные свойства
    
    /// Начальный цвет
    @IBInspectable
    var startColor: UIColor = .clear {
        didSet {
            configure()
        }
    }
    
    /// Конечный цвет
    @IBInspectable
    var endColor: UIColor = .clear {
        didSet {
            configure()
        }
    }
    
    /// Координата начального цвета
    @IBInspectable
    var startPoint: CGPoint = CGPoint(x: 0.5, y: 0) {
        didSet {
            configure()
        }
    }
    
    /// Координата конечного цвета
    @IBInspectable
    var endPoint: CGPoint = CGPoint(x: 0.5, y: 1) {
        didSet {
            configure()
        }
    }
    
}


// MARK: - Приватные свойства

extension GradientView {
    
    var gradientLayer: CAGradientLayer? {
        return self.layer as? CAGradientLayer
    }
    
}


// MARK: - UIView

extension GradientView {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

}


// MARK: - Приватные методы

private extension GradientView {
    
    /// Настройка
    func configure() {
        self.gradientLayer?.colors = [self.startColor.cgColor, self.endColor.cgColor]
    }
    
}
