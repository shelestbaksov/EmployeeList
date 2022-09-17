//
//  EmployeeListViewController.swift
//  EmployeeList
//
//  Created by Leysan Latypova on 16.09.2022.
//

import UIKit

class CompanyListViewController: UIViewController {
    
    var service: CompaniesService!
    
    private var companies: [Company] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Employees"
        navigationController?.navigationBar.prefersLargeTitles = true
        setUpTableView()
        view.addSubview(tableView)
        service.fetchCompanies(completion: { [weak self] result in
            switch result {
            case .success(let companies):
                self?.companies = companies
                self?.tableView.reloadData()
            case .failure(let error):
                print("Failed to fetch data: \(error)")
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setUpTableView() {
        tableView.register(
            EmployeeTableViewCell.self,
            forCellReuseIdentifier: EmployeeTableViewCell.identifier
        )
    }
}

// MARK: -UITableViewDelegate, UITableViewDataSource
extension CompanyListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return companies[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies[section].employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let employee = companies[indexPath.section].employees[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeTableViewCell.identifier, for: indexPath) as? EmployeeTableViewCell {
            cell.configure(with: employee)
            return cell
        }
        return UITableViewCell()
    }
}
    
