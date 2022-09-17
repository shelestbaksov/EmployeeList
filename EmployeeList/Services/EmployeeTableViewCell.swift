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
        return label
    }()
    
    private let employeePhoneLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let employeeSkillsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
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
        //contentView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(employeeNameLabel)
        stackView.addArrangedSubview(employeePhoneLabel)
        stackView.addArrangedSubview(employeeSkillsLabel)
        stackView.axis = .vertical
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 16, leading: 16, bottom: 16, trailing: 16
        )
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        super.updateConstraints()
    }
          
    func configure(with employee: Employee) {
        employeeNameLabel.text = employee.name
        employeePhoneLabel.text = employee.phone_number
        employeeSkillsLabel.text = employee.skills.joined(separator: ", ")
    }
}
