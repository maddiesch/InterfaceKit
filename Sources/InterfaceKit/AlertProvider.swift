//
//  AlertProvider.swift
//  
//
//  Created by Maddie Schipper on 3/16/21.
//

import SwiftUI

public protocol AlertProvider : Identifiable {
    var alertView: Alert { get }
}

extension View {
    public func alert<Provider : AlertProvider>(forProvider provider: Binding<Provider?>) -> some View {
        return self.alert(item: provider, content: \.alertView)
    }
}
