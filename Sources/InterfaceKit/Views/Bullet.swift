//
//  Bullet.swift
//  
//
//  Created by Maddie Schipper on 3/16/21.
//

import SwiftUI

public struct Bullet : View {
    private let circle = Circle()
    
    public let size: CGFloat
    
    public init(size: CGFloat = 4.0) {
        self.size = size
    }
    
    public var body: some View {
        circle.frame(width: size, height: size)
    }
}



struct Bullet_Previews: PreviewProvider {
    static var previews: some View {
        Bullet()
    }
}

