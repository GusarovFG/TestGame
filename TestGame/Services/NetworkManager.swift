//
//  NetworkManager.swift
//  TestGame
//
//  Created by Фаддей Гусаров on 02.04.2022.
//
import Alamofire
import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init(){}
    
    func getDrinks(with complition: @escaping (Drinks) -> Void) {
        
        let url = URL(string: DrinksURL.url.rawValue)
        
        AF.request(url!, method: .get).response { (response) in
            guard let data = response.data else { return }
            do {
                let drinks = try JSONDecoder().decode(Drinks.self, from: data)
                DispatchQueue.main.async {
                    complition(drinks)
                }
            } catch {
                print(error)
            }
            
        }
    }
}
