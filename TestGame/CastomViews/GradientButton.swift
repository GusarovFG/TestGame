//
//  GradientButton.swift
//  TestGame
//
//  Created by Фаддей Гусаров on 03.04.2022.
//

import Foundation
import UIKit

class GradientButton: UIButton {

    func changeColor() {
        let gradient = CAGradientLayer()
        
        gradient.frame = bounds
        gradient.colors = [UIColor.red.cgColor, UIColor.purple.cgColor]
        gradient.cornerRadius = 8
        self.layer.insertSublayer(gradient, at: 0)
        
        self.layer.cornerRadius = 8
    }
    
    func removeGradient() {
        self.layer.sublayers?[0].isHidden = true
        
    }
}
