//
//  File.swift
//  
//
//  Created by Daniel Ishida on 26/06/24.
//

import Foundation
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("api", "v1", "users")
        
        users.post(use: create)
    }
    
    // MARK: CRUD OPERATIONS
    
    //CREATE NEW USER
    @Sendable func create(_ req: Request) throws -> EventLoopFuture<User.Public> {
        let user = try req.content.decode(User.self)
        user.password = try Bcrypt.hash(user.password)
        return user.save(on: req.db).map {
            user.convertToPublic()
        }
    }
}
