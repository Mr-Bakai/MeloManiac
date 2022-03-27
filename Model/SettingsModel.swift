//
//  SettingsModel.swift
//  MeloManiac
//
//  Created by Bakai Ismailov on 17/1/22.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let hanler: () -> Void
}
