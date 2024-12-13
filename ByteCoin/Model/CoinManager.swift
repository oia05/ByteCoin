//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Omar Assidi on 12/12/2024.
//  Copyright © 2024 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didGetCoinPrice(_ coinManager: CoinManager, coinPrice: CoinPrice)
    func didFaileToGetCoinPrice(_ coinManager: CoinManager, error: Error)
    func didSrartLoading()
}
struct CoinManager {
    var delegate: CoinManagerDelegate?
    let apiKey = "66087143-0E0D-4158-89D0-E5A3F2F06F0F"
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR", "LBP"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        if let Url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: Url) { (data, response, error) in
                if(error == nil) {
                    if let data = data {
                        if let coinPrice = parseJson(data) {
                            delegate?.didGetCoinPrice(self, coinPrice: coinPrice)
                        }
                    }
                } else {
                    delegate?.didFaileToGetCoinPrice(self, error: error!)
                }
            }
            delegate?.didSrartLoading()
            task.resume()
        }
    }
    
    func parseJson(_ data: Data) -> CoinPrice? {
        do {
            let decoder = JSONDecoder()
            let coinPrice = try decoder.decode(CoinPrice.self, from: data)
            return coinPrice
        } catch {
            delegate?.didFaileToGetCoinPrice(self, error: error)
            return nil
        }
    }
}
