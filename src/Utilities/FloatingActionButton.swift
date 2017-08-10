//
//  FloatingActionButton.swift
//  StoermWeather
//
//  Created by Jonas Gamburg on 07/08/2017.
//  Copyright © 2017 Jonas Gamburg. All rights reserved.
//

import UIKit

class FloatingActionButton: UIButtonX {
    
    // Touch down inside
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        UIView.animate(withDuration: 0.3, animations: {
            if self.transform == .identity {
                self.transform = CGAffineTransform(rotationAngle: 45 * (.pi / 1.80))
                //self.setImage(UIImage(named: "edit1xdark"), for: .disabled)
            } else {
                self.transform = .identity
                //self.setImage(UIImage(named: "edit1x"), for: .normal)
            }
        })
        
        
        return super.beginTracking(touch, with: event)
        
    }   
}
