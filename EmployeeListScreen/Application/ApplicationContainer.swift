import Foundation
import UIKit

class ApplicationContainer: UINavigationController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if let companyListVC = viewControllers.first as? CompanyListViewController {
            let storage = CompaniesUserDefaultsStorage(
                userDefaults: UserDefaults.standard
            )
            let service = CompaniesNetworkAndStorageService(
                urlSession: URLSession.shared,
                jsonDecoder: JSONDecoder(),
                storage: storage
            )
            let presenter = CompaniesPresenter(companyListView: companyListVC, service: service)
            companyListVC.output = presenter 
        }
    }
}
