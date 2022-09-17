import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

protocol CompaniesService {
    func fetchCompanies(completion: @escaping (Result<[Company], Error>) -> Void)
}

class CompaniesNetworkAndStorageService: CompaniesService {
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    private let storage: CompaniesStorage
    
    init(urlSession: URLSession, jsonDecoder: JSONDecoder, storage: CompaniesStorage) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        self.storage = storage
    }
    
    func fetchCompanies(completion: @escaping (Result<[Company], Error>) -> Void) {
        guard let url = URL(string: "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        if let company = storage.fetchSavedCompanies(), !company.isEmpty {
            completion(.success(company))
        } else {
            urlSession.dataTask(with: url) { [weak self] data, _, error in
                guard let strongSelf = self else { return }
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                do {
                    let companyDict = try strongSelf.jsonDecoder.decode([String: Company].self, from: data)
                    if let company = companyDict["company"] {
                        DispatchQueue.main.async {
                            completion(.success([company]))
                            strongSelf.storage.save(companies: [company])
                        }
                    }
                } catch {
                    completion(.failure(NetworkError.decodingError))
                }
            }.resume()
        }
    }
}
