//
//  ErrorView.swift
//  
//
//  Created by Maddie Schipper on 12/21/20.
//

import SwiftUI

open class ErrorPresenter : Identifiable {
    public let error: Error
    
    public init(error: Error) {
        self.error = error
    }
    
    open func alertView() -> Alert {
        return Alert(
            title: Text("IFK-ErrorPresenterAlertTitle"),
            message: Text(error.localizedDescription)
        )
    }
}
