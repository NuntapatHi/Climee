//
//  Extensions.swift
//  Climee
//
//  Created by Nuntapat Hirunnattee on 28/8/2565 BE.
//

import Foundation
import UIKit

extension UIViewController {
    
//MARK: - Close keyboard when touch around
    func dismissKeybaordWhenTouchAround(){
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
