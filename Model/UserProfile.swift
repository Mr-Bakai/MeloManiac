//
//  UserProfile.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 10/1/22.
//
import Foundation

struct UserProfile: Codable {
    let country: String
    let display_name: String
    let explicit_content: [String : Bool]
    let external_urls: [String : String]
    let id: String
    let product: String
    let images: [APIImage]
}

