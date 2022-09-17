//
//  NetworkManager.swift
//  EmployeeList
//
//  Created by Leysan Latypova on 16.09.2022.
//

import Foundation

enum NetworkManagerError: Error {
    case invalidURL
    case noData
    case decodingError
}

class EmployeeListService {
    func fetchEmployeeList(completion: @escaping (Result<[Company], Error>) -> Void) {
        guard let url = URL(string: "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c") else {
            completion(.failure(NetworkManagerError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(NetworkManagerError.noData))
                return
            }
            
            do {
                let companyDict = try JSONDecoder().decode([String: Company].self, from: data)
                if let company = companyDict["company"] {
                    DispatchQueue.main.async {
                        completion(.success([company]))
                    }
                }
            } catch {
                completion(.failure(NetworkManagerError.decodingError))
            }
        }.resume()
    }
}
