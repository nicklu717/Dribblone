//
//  Date+Extension.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/18.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import Foundation

extension Date {
    
    func string(format: DateFormat) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format.rawValue
        
        return dateFormatter.string(from: self)
    }
    
    enum DateFormat: String {
        
        case resultDisplay = "MMM-dd HH:mm"
    }
}
