//
//  ButtonModifier.swift
//  TabuLand
//
//  Created by Bahadır Kılınç on 7.07.2022.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.headline)
      .padding()
      .frame(minWidth: 0, maxWidth: .infinity)
      .background(Capsule().fill(Color.pink))
      .foregroundColor(Color.white)
  }
}
struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 15.0, *) {
            configuration.label
                .padding()
                .background(.red)
                .foregroundColor(Color("shinyYellow"))
                .clipShape(Capsule())
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        } else {
            // Fallback on earlier versions
        }
    }
}
