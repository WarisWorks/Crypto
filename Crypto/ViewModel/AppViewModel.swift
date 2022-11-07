//
//  AppViewModel.swift
//  Crypto
//
//  Created by MaaS on 2022/11/07.
//

import SwiftUI

class AppViewModel: ObservableObject {
    @Published var coins: [CryptoModel]?
    @Published var currentCoin: CryptoModel?
    
    init(){
        Task{
            do{
                try await fetchCryptoData()
            }catch {
                //MARK: Handle Error
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: Fetching Crypto Data
    func fetchCryptoData()async throws{
        //MARK: Using Latest Async/Await
        guard let url = url else{return}
        let sesstion = URLSession.shared
        
        let response = try await sesstion.data(from: url)
        let jsonData = try JSONDecoder().decode([CryptoModel].self, from: response.0)
        
        // Alternative For DispatchQueue Main
        await MainActor.run(body: {
            self.coins = jsonData
            if let firstCoin = jsonData.first{
                self.currentCoin = firstCoin
            }
        })
    }
}

