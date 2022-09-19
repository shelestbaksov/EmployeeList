import Foundation

enum CompaniesStorageError: Error {
    case invalidURL
    case noData
    case decodingError
}

protocol CompaniesService {
    func fetchCompanies(completion: @escaping (Result<[Company], Error>) -> Void)
}

final class CompaniesNetworkAndStorageService: CompaniesService {
    
    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder
    private let storage: CompaniesStorage
    
    // MARK: - Init
    init(urlSession: URLSession, jsonDecoder: JSONDecoder, storage: CompaniesStorage) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        self.storage = storage
    }
    
    // MARK: - CompaniesService
    func fetchCompanies(completion: @escaping (Result<[Company], Error>) -> Void) {
        guard let url = URL(string: "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c") else {
            completion(.failure(CompaniesStorageError.invalidURL))
            return
        }

        if let companies = storage.fetchSavedCompanies() {
            completion(.success(companies))
        } else {
            urlSession.dataTask(with: url) { [weak self] data, _, error in
                guard let strongSelf = self else { return }
                guard let data = data else {
                    completion(.failure(error ?? CompaniesStorageError.noData))
                    return
                }
                
                do {
                    let companyDict = try strongSelf.jsonDecoder.decode([String: Company].self, from: data)
                    if var company = companyDict["company"] {
                        DispatchQueue.main.async {
                            company.employees = company.employees.sorted(by: {
                                if $0.name == $1.name {
                                    return $0.phone_number < $1.phone_number
                                } else {
                                    return $0.name < $1.name
                                }
                            })
                            completion(.success([company]))
                            strongSelf.storage.save(companies: [company])
                        }
                    }
                } catch {
                    completion(.failure(CompaniesStorageError.decodingError))
                }
            }.resume()
        }
    }
}

