//
//  ContentType.swift
//  ContentType
//
//  Created by Linus Skucas on 8/28/21.
//

import Foundation

enum ContentType: String, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case text = "public.string"
    case url = "public.url"
    case image = "public.image"  // https://developer.apple.com/documentation/quartz/ikpicturetaker
//    case file = "public.data"
}
