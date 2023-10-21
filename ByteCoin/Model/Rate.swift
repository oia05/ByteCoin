//
//  Rate.swift
//  ByteCoin
//
//  Created by OmarAssidi on 21/10/2023.
//  Copyright © 2023 The App Brewery. All rights reserved.
//

import Foundation

struct Rate: Decodable {
    let time: String
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
