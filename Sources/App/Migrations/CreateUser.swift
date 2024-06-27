//
//  CreateUser.swift
//
//
//  Created by Daniel Ishida on 26/06/24.
//

import Foundation
import Fluent
import Vapor

struct CreateUser : AsyncMigration {
    func prepare(on database: any FluentKit.Database) async throws {
        try await database.schema(User.schema)
            .id()
            .field("USER_EMAIL", .string, .required)
            .field("USER_PASSWORD", .string, .required)
            .unique(on: "USER_EMAIL")
            .create()
        
        let user = User(email: "user@gmail.com", password: try Bcrypt.hash("123"))
        try await user.save(on: database)
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(User.schema)
            .delete()
    }
}
