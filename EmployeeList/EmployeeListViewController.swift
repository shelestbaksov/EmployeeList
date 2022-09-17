//
//  EmployeeListViewController.swift
//  EmployeeList
//
//  Created by Leysan Latypova on 16.09.2022.
//

import UIKit

class EmployeeListViewController: UIViewController {
    
    var companies: [Company] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(EmployeeTableViewCell.self,
                       forCellReuseIdentifier: EmployeeTableViewCell.identifier)
        table.insetsContentViewsToSafeArea = true
        return table
    }()
    
    var service = EmployeeListService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Employees"
        navigationController?.navigationBar.prefersLargeTitles = true
        setUpTableView()
        view.addSubview(tableView)
        service.fetchEmployeeList { [weak self] result in
            switch result {
            case .success(let companies):
                self?.companies = companies
                self?.tableView.reloadData()
            case .failure(let error):
                print("Failed to fetch data: \(error)")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: -UITableViewDelegate, UITableViewDataSource
extension EmployeeListViewController: UITableViewDelegate, UITableViewDataSource {
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
    
