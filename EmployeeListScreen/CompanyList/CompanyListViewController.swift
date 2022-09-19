import UIKit

protocol CompanyListViewOutput {
    func onViewDidLoad()
    func buttonPressed()
}

final class CompanyListViewController: UIViewController, CompanyListView {
    
    var output: CompanyListViewOutput!
    
    private var companies: [CompanyViewData] = []
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setupNoDataLabel()
        output.onViewDidLoad()
    }
    
    @IBAction func retryButtonPressed() {
        output.buttonPressed()
    }
    
    // MARK: - Private functions
    private func setUpTableView() {
        tableView.register(
            EmployeeTableViewCell.self,
            forCellReuseIdentifier: EmployeeTableViewCell.identifier
        )
    }
    
    private func setupNoDataLabel() {
        errorLabel.textAlignment = .center
        errorLabel.textColor = .gray
        errorLabel.font = .systemFont(ofSize: 21, weight: .medium)
    }
    
    // MARK: - CompanyListView
    func showSpinner() {
        activityIndicator.startAnimating()
        tableView.isHidden = true
        errorLabel.isHidden = true
        retryButton.isHidden = true
    }
    
    func hideSpinner() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func showViewData(viewData: [CompanyViewData]) {
        companies = viewData
        tableView.isHidden = false
        errorLabel.isHidden = true
        retryButton.isHidden = true
        tableView.reloadData()
    }
    
    func showErrorLabel(text: String) {
        errorLabel.isHidden = false
        retryButton.isHidden = false
        tableView.isHidden = true
        errorLabel.text = text
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CompanyListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return companies.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return companies[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies[section].cellDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let employee = companies[indexPath.section].cellDatas[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.identifier, for: indexPath) as? EmployeeTableViewCell {
            cell.configure(with: employee)
            return cell
        }
        return UITableViewCell()
    }
}
