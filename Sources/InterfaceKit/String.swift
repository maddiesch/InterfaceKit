//
//  String.swift
//  
//
//  Created by Maddie Schipper on 4/9/21.
//

import Foundation

extension String {
    public init(_ value: Any?, formatter: Formatter) {
        self = formatter.string(for: value) ?? "<Formatter Failure>"
    }
}
