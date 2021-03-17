//
//  ErrorView.swift
//  
//
//  Created by Maddie Schipper on 12/21/20.
//

import SwiftUI

open class ErrorPresenter : Identifiable {
    public let error: Error
    
    public let title: Text
    
    public init(title: Text, error: Error) {
        self.title = title
        self.error = error
    }
    
    open var alertView: Alert {
        return Alert(
            title: self.title,
            message: Text(error.localizedDescription)
        )
    }
}
