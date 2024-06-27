//
//  AuthMiddleware.swift
//
//
//  Created by Daniel Ishida on 26/06/24.
//

import Foundation
import Vapor
import Fluent


final class UserAuthenticator : AsyncBasicAuthenticator, Middleware {
    func authenticate(basic: Vapor.BasicAuthorization, for request: Vapor.Request) async throws {
        
        
        
        guard let user = try await User.query(on: request.db)
            .filter(\.$email == basic.username)
            .first() else {
            throw Abort(.unauthorized)
        }
        guard try Bcrypt.verify(basic.password, created: user.password) else {
            throw Abort(.unauthorized)
        }
        request.auth.login(user)
    }
   
    
}
