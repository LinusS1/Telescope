//
//  URL+Convenience.swift
//  URL+Convenience
//
//  Created by Linus Skucas on 9/9/21.
//

import Foundation
import UniformTypeIdentifiers

extension URL {
    var typeIdentifier: UTType? { try? self.resourceValues(forKeys: [.contentTypeKey]).contentType }
}
