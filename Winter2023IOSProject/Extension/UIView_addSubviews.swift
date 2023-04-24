//
//  UIView_addSubviews.swift
//  IOS-SWIFT-MyComponentLibrary
//
//  Created by Daniel Carvalho on 2023-02-14.
//

import UIKit


extension UIView{
    
    func addSubviews( _ views : UIView... ){
        for view in views{
            self.addSubview(view)
        }
    }
    
    
}
