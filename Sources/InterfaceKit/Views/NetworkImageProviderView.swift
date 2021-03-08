//
//  NetworkImageProviderView.swift
//  
//
//  Created by Maddie Schipper on 3/4/21.
//

import SwiftUI
import Combine

#if canImport(Cocoa)
import Cocoa

public typealias NativeImage = NSImage
#else
import UIKit

public typealias NativeImage = UIImage
#endif

extension Image {
    public init(native: NativeImage) {
        #if canImport(Cocoa)
            self.init(nsImage: native)
        #else
            self.init(uiImage: native)
        #endif
    }
}

private let networkImageProviderCache = NSCache<NSString, NativeImage>()

/// NetworkImageProviderView
///
/// Provides a standard interface for loading images from the network
public struct NetworkImageProviderView<Content : View> : View {
    private let contentProvider: (NativeImage) -> Content
    
    private let placeholder: AnyView
    
    private let publisher: AnyPublisher<NativeImage?, Never>
    
    @State var nativeImage: NativeImage? = nil
    
    public init(url: URL, placeholder: AnyView? = nil, @ViewBuilder provider: @escaping (NativeImage) -> Content) {
        self.contentProvider = provider
        self.placeholder = placeholder ?? AnyView(EmptyView())
        
        let cacheKey = NSString(string: url.absoluteString)
        
        self.publisher = InterfaceSession.dataTaskPublisher(for: url).requireOkayResponse().map(\.data).map {
            let image = NativeImage(data: $0)
            
            if let image = image {
                networkImageProviderCache.setObject(image, forKey: cacheKey)
            }
            
            return image
        }.replaceError(with: nil).receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    public var body: some View {
        return ZStack { () -> AnyView in
            if let image = self.nativeImage {
                return AnyView(self.contentProvider(image))
            }
            return AnyView(self.placeholder)
        }.onReceive(self.publisher, perform: { image in
            self.nativeImage = image
        })
    }
}
