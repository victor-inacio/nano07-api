//
//  File.swift
//  
//
//  Created by Daniel Ishida on 21/06/24.
//

import Foundation
import Fluent

struct CreateBook : AsyncMigration{
    func prepare(on database: any FluentKit.Database) async throws {
        try await database.schema(Book.schema)
            .id()
            .field("BOOK_NAME", .string)
            .field("BOOK_AUTHOR", .string)
            .create()
    }
    
    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) async throws {
        try await database.schema(Book.schema).delete()
    }
}
