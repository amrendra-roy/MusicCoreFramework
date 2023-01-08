//
//  UserLoginRequest.swift
//  MusicCoreFramework
//
//  Created by Amrendra on 16/10/21.
//

import Foundation

struct UserLoginRequest: Codable {
    
    let email: String
    let password: String
    let sign: String

    init(email mail: String, password: String, sing: String) {
        self.email = mail
        self.password = password
        self.sign = "a94c489baed0ec4554830003398277b6"
    }
}

extension UserLoginRequest: MusicEndpoint {
    var path: String {
        return "/api/Login"
    }
    
    var request: URLRequest {
        var request = URLRequest(url: self.requestURL)
        request.httpMethod = "POST"
        request.httpBody = self.jsonifiedData()

        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
