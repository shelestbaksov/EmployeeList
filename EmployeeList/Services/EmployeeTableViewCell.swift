//
//  EmployeeTableViewCell.swift
//  EmployeeList
//
//  Created by Leysan Latypova on 16.09.2022.
//

import Foundation
import UIKit

class EmployeeTableViewCell: UITableViewCell {
    static let identifier = "EmployeeTableViewCell"
    
    private let employeeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let employeePhoneLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let employeeSkillsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(employeeNameLabel)
        stackView.addArrangedSubview(employeePhoneLabel)
        stackView.addArrangedSubview(employeeSkillsLabel)
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 5
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10)
        ])
    }
          
    func configure(with employee: Employee) {
        employeeNameLabel.text = employee.name
        employeePhoneLabel.text = employee.phone_number
        employeeSkillsLabel.text = employee.skills.joined(separator: ", ")
    }
}
