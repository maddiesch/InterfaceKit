//
//  KeyboardAvoidingModifier.swift
//  
//
//  Created by Maddie Schipper on 4/4/21.
//

import SwiftUI
import Combine

#if canImport(UIKit)

import UIKit

public struct KeyboardAvoidingModifier : ViewModifier {
    public init() {}
    
    @State private var bottomPadding: CGFloat = 0.0
    
    private var publisher = createKeyboardHeightChangePublisher()
    
    public func body(content: Content) -> some View {
        return GeometryReader { geometry in
            content
                .padding(.bottom, bottomPadding)
                .onReceive(publisher) { keyboardHeight in
                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                    let focusedFirstResponderBottom = UIResponder.tel_currentFirstResponder?.globalFrame?.minY ?? 0.0
                    self.bottomPadding = max(0.0, focusedFirstResponderBottom - keyboardTop - geometry.safeAreaInsets.bottom)
                }
                .animation(.easeOut(duration: 0.16))
        }
    }
}

fileprivate extension Notification {
    var _keyboardHeight: CGFloat {
        return (self.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0.0
    }
}

fileprivate func createKeyboardHeightChangePublisher() -> AnyPublisher<CGFloat, Never> {
    let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification).map(\._keyboardHeight)
    let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification).map(\._keyboardHeight)
    
    return Publishers.Merge(willShow, willHide).eraseToAnyPublisher()
}

fileprivate extension UIResponder {
    static var tel_currentFirstResponder: UIResponder? {
        _tel_currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.tel_findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _tel_currentFirstResponder
    }

    private static weak var _tel_currentFirstResponder: UIResponder?

    @objc private func tel_findFirstResponder(_ sender: Any) {
        UIResponder._tel_currentFirstResponder = self
    }

    var globalFrame: CGRect? {
        guard let view = self as? UIView else {
            return nil
        }
        
        return view.superview?.convert(view.frame, to: nil)
    }
}

#else

public struct KeyboardAvoidingModifier : ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        return content
    }
}

#endif
