//
//  RoundedCorners+ViewExtension.swift
//  FunSeeker
//
//  Created by Muhammed Kocabas on 2023-07-01.
//

import SwiftUI

extension View {
    /// Applies a corner radius with specific corners to the view.
    ///
    /// - Parameters:
    ///   - radius: The radius to use for the corners.
    ///   - corners: The corners to apply the radius to.
    /// - Returns: A modified view with the specified corner radius applied.
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    /// The radius to use for the corners.
    var radius: CGFloat = .infinity

    /// The corners to apply the radius to.
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        // Create a UIBezierPath for the rounded rectangle with specified corner radii and bounds
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        // Convert the UIBezierPath to a SwiftUI Path and return
        return Path(path.cgPath)
    }
}
