//
//  TimeInterval.swift
//  
//
//  Created by Maddie Schipper on 3/4/21.
//

import Foundation

extension TimeInterval {
    public static func milliseconds(_ milliseconds: TimeInterval) -> TimeInterval {
        return milliseconds * 0.001
    }
    
    public static func minutes(_ minutes: TimeInterval) -> TimeInterval {
        return minutes * 60.0
    }
    
    public static func hours(_ hours: TimeInterval) -> TimeInterval {
        return hours * 3600.0
    }
    
    public static func days(_ days: TimeInterval) -> TimeInterval {
        return days * 86400.0
    }
}
