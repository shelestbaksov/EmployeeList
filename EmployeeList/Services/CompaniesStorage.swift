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
            let timeinterval = Date().timeIntervalSince1970
            userDefaults.set(timeinterval, forKey: timeKey)
        }
    }
    
    func fetchSavedCompanies() -> [Company]? {
        let savedTime = userDefaults.double(forKey: timeKey)
        
        if let data = userDefaults.data(forKey: key) {
            if Date().timeIntervalSince1970 - savedTime == 3600 {
                if let decoded = try? JSONDecoder().decode([Company].self, from: data) {
                    return decoded
                }
            }
        }
        return []
    }
}
