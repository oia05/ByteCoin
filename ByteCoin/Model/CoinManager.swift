//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation


protocol CoinManagerDelegate {
    func updateRate(rate: RateModel)
    func setError(error: Error)
}

struct CoinManager {
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "39AB2E23-A471-4E74-B294-37ABA7B1F1B6"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR", "LBP"]
    
    var delegate: CoinManagerDelegate?

    func getCoinPrice(for currency: String) {
        let url = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(url: url)
    }
    
    private func performRequest(url: String) {
        // 1- Create URL Object
        guard let urlObject = URL(string: url) else {
            print("urlObject is nil")
            return}
        
        // 2- Create URL Session
        let session = URLSession(configuration: .default)
        
        // 3- Give a task to the session
        let task = session.dataTask(with: urlObject) {data, response, error in
            if error != nil {
                delegate?.setError(error: error!)
                return
            }
            
            if let data = data {
                if let rateModel = parseJson(data: data) {
                    delegate?.updateRate(rate: rateModel)
                }
            }
        }
        
        // 4- resume the taks
        task.resume()
    }
    
    private func parseJson(data: Data) -> RateModel? {
        let decoder = JSONDecoder()
        do {
            let rate = try decoder.decode(Rate.self, from: data)
            let rateModel = RateModel(rate: rate.rate, currency: rate.asset_id_quote)
            return rateModel
        } catch {
            delegate?.setError(error: error)
            return nil
        }
    }
}
