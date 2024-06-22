//
//  BookController.swift
//
//
//  Created by Daniel Ishida on 21/06/24.
//
import Fluent
import Vapor
import Foundation

struct BookController : RouteCollection{
    //MARK: CONFIGURE ROUTES
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let books = routes.grouped("books")
        books.get(use: index)
        books.post(use: create)
        
        //Individual operations using id as a parameter
        books.group(":id") { todo in
            books.put(use: update)
            books.delete(use: delete)
        }
    }
    
    //MARK: CRUD OPERATIONS IMPLEMENTATIONS
    
    //RETURN ALL BOOKS
    @Sendable func index(req: Request) async throws -> [Book] {
         try await Book.query(on: req.db).all()
    }
    
    //REATE A NEW BOOK
    @Sendable func create(req: Request) async throws -> Book {
        let todo = try req.content.decode(Book.self)
        try await todo.save(on: req.db)
        return todo
    }

    //RETURN SPECIFIC BOOK BY ID
    @Sendable func show(req: Request) async throws -> Book {
        guard let book = try await Book.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return book
    }
    
    //UPDATE SPECIFIC BOOK BY ID
    @Sendable func update(req : Request) async throws -> Book {
        guard let book = try await Book.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let updatedBook = try req.content.decode(Book.self)
        book.name = updatedBook.name
        book.author = updatedBook.author
        try await book.save(on: req.db)
        
        return book
    }
    
    //DELETE SPECIFIC BOOK BY ID
    @Sendable func delete(req : Request) async throws -> HTTPStatus {
        guard let book = try await Book.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await book.delete(on: req.db)
        return .ok
    }
}
