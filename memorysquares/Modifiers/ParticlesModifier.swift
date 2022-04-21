//
//  ParticlesModifier.swift
//  memorysquares
//
//  Created by Tyler Reed on 4/21/22.
//

import SwiftUI

struct ParticlesModifier: ViewModifier {
    @State var time = 0.0
    @State var scale = 0.01
    let duration = 1.5
    
    func body(content: Content) -> some View {
        ZStack {
            ForEach(0..<20, id: \.self) { index in
                content
                    .hueRotation(Angle(degrees: time * 90))
                    .scaleEffect(scale)
                    .modifier(FireworkParticlesGeometryEffect(time: time))
                    .foregroundColor(.blue)
                    .opacity(((duration-time) / duration))
            }
        }
        .onAppear {
            withAnimation (.easeOut(duration: duration)) {
                self.time = duration
                self.scale = 0.15
            }
        }
    }
}
