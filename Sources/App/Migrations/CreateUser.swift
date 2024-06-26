//
//  CreateUser.swift
//
//
//  Created by Daniel Ishida on 26/06/24.
//

import Foundation
import Fluent

struct CreateUser : AsyncMigration {
    func prepare(on database: any FluentKit.Database) async throws {
        try await database.schema(User.schema)
            .id()
            .field("email", .string, .required)
            .field("password", .string, .required)
            .unique(on: "email")
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        try await database.schema(User.schema)
            .delete()
    }
}
