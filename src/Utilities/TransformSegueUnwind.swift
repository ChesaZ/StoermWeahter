//
//  TransformSegueUnwind.swift
//  StoermWeather
//
//  Created by Jonas Gamburg on 30/07/2017.
//  Copyright © 2017 Jonas Gamburg. All rights reserved.
//

import UIKit

class transofrmSegueUnwind: UIStoryboardSegue {
    
    override func perform() {
        
        let secondView = self.source.view as UIView!
        let firstView = self.destination.view as UIView!
        
        firstView?.frame = CGRect(x: 0, y: -700, width: 0, height: 0)
        
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(firstView!, aboveSubview: secondView!)
        
        print("unwind segue 2")
        
        // Animate the transition.
        UIView.animate(withDuration: 0.7, animations: { () -> Void in
            firstView?.frame = UIScreen.main.bounds
            
        }) { (Finished) -> Void in
            
            self.source.dismiss(animated: false, completion: nil)
        }
    }
    
}
