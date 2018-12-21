//
//  TimeInterval+Conversions.swift
//  ProtocolOrientedNetworking_Example
//
//  Created by Pedro Brito on 20/12/2018.
//  Copyright © 2018 pmlbrito. All rights reserved.
//

import Foundation

extension TimeInterval{
    
    func toTimestampString() -> String {
        
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
        
    }
}
