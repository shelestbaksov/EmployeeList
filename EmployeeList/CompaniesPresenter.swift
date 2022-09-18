import Foundation

protocol CompanyListView: AnyObject {
    func showSpinner()
    func hideSpinner()
    func showCompanies(companies: [Company])
    func showErrorLabel(text: String)
}

class CompaniesPresenter: CompanyListViewOutput {

    weak var view: CompanyListView?
    var service: CompaniesService!
    
    init(companyListView: CompanyListView) {
        self.view = companyListView
    }
    
    func buttonPressed() {
        loadData()
    }
    
    func onViewDidLoad() {
        loadData()
    }
    
    private func loadData() {
        self.view?.showSpinner()
        
        service.fetchCompanies(completion: { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideSpinner()
                
                switch result {
                case .success(let companies):
                    self?.view?.showCompanies(companies: companies)
                    
                case .failure(let error):
                    if error.isNetworkConnectionError() {
                        let text = "No internet connection"
                        self?.view?.showErrorLabel(text: text)
                    } else {
                        let text = "No data"
                        self?.view?.showErrorLabel(text: text)
                    }
                    
                }
            }
        })
    }
}

extension Error {
    func isNetworkConnectionError() -> Bool {
        let networkErrors = [NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet]

        let error = self as NSError
        
        return networkErrors.contains(error.code)
    }
}
