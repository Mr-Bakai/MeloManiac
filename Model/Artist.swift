//
//  Artist.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 18/1/22.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String: String]
}
