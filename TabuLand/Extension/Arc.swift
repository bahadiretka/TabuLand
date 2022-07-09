//
//  Arc.swift
//  TabuLand
//
//  Created by Bahadır Kılınç on 8.07.2022.
//
import SwiftUI

struct Arc: InsettableShape {
    var endAngle: Angle
    var insetAmount: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        Path { p in
            p.addArc(center: CGPoint(x: rect.midX, y: rect.midY),
                     radius: rect.width / 2 - insetAmount,
                     startAngle: .degrees(-90),
                     endAngle: endAngle - Angle(degrees: 90),
                     clockwise: false)
        }
    }

    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}
