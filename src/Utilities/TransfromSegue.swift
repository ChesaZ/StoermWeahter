//
//  TransformSegue.swift
//  StoermWeather
//
//  Created by Jonas Gamburg on 30/07/2017.
//  Copyright © 2017 Jonas Gamburg. All rights reserved.
//

import UIKit

class transformSegue: UIStoryboardSegue {
    
    override func perform() {
        //scale view up
        
        let firstView = self.source.view as UIView!
        let secondView = self.destination.view as UIView!
        
        // Get the screen width and height.
        //let screenWidth = UIScreen.main.bounds.size.width
        //let screenHeight = UIScreen.main.bounds.size.height
        
        //secondView?.frame = (self.source as! MainViewVC).getCellPosition()
        secondView?.frame = CGRect(x: 0, y: -700, width: 0, height: 0)
        
        // Access the app's key window and insert the destination view above the current (source) one.
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondView!, aboveSubview: firstView!)
        
        
        //Animate the transition
        UIView.animate(withDuration: 0.7, animations: {
            secondView?.frame = UIScreen.main.bounds
        }) { (Finished) -> Void in
            self.source.present(self.destination as UIViewController, animated: false, completion: nil)
        }
        print("View has grown.")
    }
}
