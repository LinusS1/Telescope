//
//  View+Convenience.swift
//  View+Convenience
//
//  Created by Linus Skucas on 8/22/21.
//

import SwiftUI

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
