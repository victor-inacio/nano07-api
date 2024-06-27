//
//  UserModel.swift
//
//
//  Created by Daniel Ishida on 26/06/24.
//

import Foundation
import Vapor
import Fluent

final class User : Model, Content, @unchecked Sendable{
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "USER_EMAIL")
    var email: String
    
    @Field(key: "USER_PASSWORD")
    var password: String
    
    init() { }
    
    init(id: UUID? = nil, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
    
    // Creating a class to hide the passwrod in response
    final class Public: Content {
        var id: UUID?
        var email: String
        
        init(id: UUID?, email: String) {
            self.id = id
            self.email = email
        }
    }
}

extension User{
    func convertToPublic() -> User.Public {
        return User.Public(id: id, email: email)
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$password

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}


