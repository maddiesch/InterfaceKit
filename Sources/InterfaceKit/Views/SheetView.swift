//
//  SheetView.swift
//  
//
//  Created by Maddie Schipper on 3/14/21.
//

import SwiftUI

public struct SheetView<Content : View> : View {
    private let content: Content
    
    private let title: LocalizedStringKey
    
    private let closeButtonImageName: String
    
    @Environment(\.presentationMode) private var presentation
    
    public init<S>(title: S, closeButtonImageName: String = "xmark.circle.fill", @ViewBuilder content: () -> Content) where S : StringProtocol {
        self.content = content()
        self.title = LocalizedStringKey(stringLiteral: String(title))
        self.closeButtonImageName = closeButtonImageName
    }
    
    public var body: some View {
        VStack {
            HStack {
                Button(action: dismissAction) {
                    Image(systemName: self.closeButtonImageName)
                }.buttonStyle(PlainButtonStyle()).keyboardShortcut(.escape)
                Spacer()
            }.foregroundColor(.secondary)
            Text(self.title).font(.largeTitle)
            ZStack {
                self.content
            }
        }.padding()
    }
        
    private func dismissAction() {
        withAnimation {
            self.presentation.wrappedValue.dismiss()
        }
    }
}
