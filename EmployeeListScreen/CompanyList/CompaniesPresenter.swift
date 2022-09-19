import Foundation

protocol CompanyListView: AnyObject {
    func showSpinner()
    func hideSpinner()
    func showViewData(viewData: [CompanyViewData])
    func showErrorLabel(text: String)
}

final class CompaniesPresenter: CompanyListViewOutput {

    weak var view: CompanyListView?

    private var service: CompaniesService!
    
    // MARK: - Init
    init(companyListView: CompanyListView, service: CompaniesService) {
        self.view = companyListView
        self.service = service
    }
    
    // MARK: - CompanyListViewOutput
    func buttonPressed() {
        loadData()
    }
    
    func onViewDidLoad() {
        loadData()
    }

    // MARK: - Private functions
    private func loadData() {
        view?.showSpinner()
        
        service.fetchCompanies(completion: { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideSpinner()
                
                switch result {
                case .success(let companies):
                    self?.view?.showViewData(
                        viewData: companies.map { company in
                            CompanyViewData(sectionTitle: company.name, cellDatas: company.employees.map { employee in
                                EmployeeCellViewData(
                                    nameLabelText: employee.name,
                                    phoneLabelText: "Phone: \(employee.phone_number)",
                                    skillsLabelText: "Skills: \(employee.skills.joined(separator: ", "))"
                                )
                            })
                        }
                    )
                    
                case .failure(let error):
                    if error.isNetworkConnectionError() {
                        self?.view?.showErrorLabel(text: "No internet connection")
                    } else {
                        self?.view?.showErrorLabel(text: "No data")
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
