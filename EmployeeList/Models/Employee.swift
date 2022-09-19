import Foundation

struct Employee: Codable {
    let name: String
    let phone_number: String
    let skills: [String]
}

struct Company: Codable {
    let name: String
    var employees: [Employee]
}
