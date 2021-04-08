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

public enum NativeImageLoaderError : Error {
    case failedImageCreationFromData(Data)
}

extension NativeImage {
    public static func nativeImageNetworkPublisher(for url: URL) -> AnyPublisher<NativeImage, Error> {
        let cacheKey = NSString(string: url.absoluteString)
        
        if let cachedNativeImage = networkImageProviderCache.object(forKey: cacheKey) {
            return Just(cachedNativeImage).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        
        return UserInterface.networkSession.dataTaskPublisher(for: url).require(httpStatusWithinRange: (200..<300)).map(\.data)
                .tryMap {
                    guard let image = NativeImage(data: $0) else {
                        throw NativeImageLoaderError.failedImageCreationFromData($0)
                    }
                    
                    networkImageProviderCache.setObject(image, forKey: cacheKey)
                        
                    return image
                }
                .eraseToAnyPublisher()
    }
}

/// NetworkImageProviderView
///
/// Provides a standard interface for loading images from the network
public struct NetworkImageProviderView<Content : View, Placeholder : View> : View {
    private let contentProvider: (NativeImage) -> Content
    
    private let placeholder: Placeholder
    
    private let publisher: AnyPublisher<NativeImage?, Never>
    
    @State var nativeImage: NativeImage? = nil
    
    public init(url: URL, @ViewBuilder provider: @escaping (NativeImage) -> Content) where Placeholder == EmptyView {
        self.init(url: url, placeholder: EmptyView(), provider: provider)
    }
    
    public init(url: URL, placeholder: Placeholder, @ViewBuilder provider: @escaping (NativeImage) -> Content) {
        self.contentProvider = provider
        self.placeholder = placeholder
        
        self.publisher = NativeImage.nativeImageNetworkPublisher(for: url)
            .flatMap { Optional.Publisher($0) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public var body: some View {
        ZStack {
            if let image = self.nativeImage {
                AnyView(self.contentProvider(image))
            } else {
                AnyView(self.placeholder)
            }
        }.onReceive(self.publisher) { image in
            self.nativeImage = image
        }
    }
}

struct NetworkImageProviderView_Previews : PreviewProvider {
    static let url = URL(string: "https://me.maddiesch.com/content/images/2021/03/LogoColor@2x.png")!
    
    static var previews: some View {
        NetworkImageProviderView(url: url) {
            Image(native: $0).frame(width: 100, height: 100)
        }.padding()
    }
}
