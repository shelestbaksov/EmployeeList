import Foundation

protocol CompaniesStorage {
    func save(companies: [Company])
    func fetchSavedCompanies() -> [Company]?
}

class CompaniesUserDefaultsStorage: CompaniesStorage {
    
    private var userDefaults: UserDefaults
    private let key = "companies"
    private let timeKey = "last saved date"
    
    // MARK: - Init
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    // MARK: - CompaniesStorage
    func save(companies: [Company]) {
        if let encoded = try? JSONEncoder().encode(companies) {
            userDefaults.set(encoded, forKey: key)
            let timeNow = Date().timeIntervalSince1970
            userDefaults.set(timeNow, forKey: timeKey)
        }
    }
    
    func fetchSavedCompanies() -> [Company]? {
        if let data = userDefaults.data(forKey: key) {
            let savedTime = userDefaults.double(forKey: timeKey)
            let currentTime = Date().timeIntervalSince1970
            if currentTime - savedTime <= 3600 {
                if let decoded = try? JSONDecoder().decode([Company].self, from: data) {
                    return decoded
                }
            }
        }
        return nil
    }
}
