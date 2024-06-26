@testable import App
import XCTVapor



final class AppTests: XCTestCase {
    var app: Application!

    override func setUpWithError() throws {
        self.app = Application(.testing)
        
        try configure(app)
    }
    
    override func tearDownWithError() throws {
        self.app.shutdown()
        self.app = nil
    }
    
    //Test index endpoint funcrion
    func testIndexEndpoint() throws {
        let book: Book = .init(id: nil, name: "Foo_Book", author: "Foo_Author")
        
        try book.save(on: app.db).wait()
        
        try app.test(.GET, "/books") { res in
            XCTAssertEqual(res.status, .ok)
            
            let returned_books = try res.content.decode([Book].self)
            let retBook = returned_books[0]
            
            XCTAssertNotNil(retBook.id)
            XCTAssertEqual("Foo_Book", retBook.name)
            XCTAssertEqual("Foo_Author", retBook.author)
        }
    }
    
    //Test create endpoint fucntion
    func testCreateBookEndpoint() throws {
        
        let name = "Test_Name"
        let author = "Test_Author"
    
        
        try app.test(.POST, "books", beforeRequest: {
            req in
            try req.content.encode([
                "name": name,
                "author": author
            ])
        }) { res in
            
            XCTAssertEqual(res.status, .ok)
            
            let returnedBook = try res.content.decode(Book.self)
            
            XCTAssertNotNil(returnedBook.id)
            XCTAssertEqual(returnedBook.name, name)
            XCTAssertEqual(returnedBook.author, author)
        }
        
    }
    
    func testCreateBookFailWhenBookNameMissing() throws {
        
        let author = "Test_Author"
        
        try app.test(.POST, "books", beforeRequest: {
            req in
            try req.content.encode([
                "author": author
            ])
        }) { res in
            
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertTrue(try res.content.get(at: "error"))

        }
        
    }
    
    func testCreateBookFailWhenBookAuthorMissing() throws {
        
        let name = "Test_Name"
        
        try app.test(.POST, "books", beforeRequest: {
            req in
            try req.content.encode([
                "name": name
            ])
        }) { res in
            
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertTrue(try res.content.get(at: "error"))
        }
        
    }
    
    func testCreateBookFailWhenNoContent() throws {
        
        
        try app.test(.POST, "books") { res in
        
            XCTAssertNotEqual(res.status, .ok)
            
        }
        
    }
    
    func testDeleteBookUsingValidID() throws {
        
        let book = Book(name: "Test_Name", author: "Test_Author")
        try book.save(on: app.db).wait()
        
        try app.test(.DELETE, "books/\(book.id!)") { res in
            
            XCTAssertEqual(res.status, .ok)
            
        }
        
    }
    
    func testDeleteBookUsingInvalidID() throws {
        
        try app.test(.DELETE, "books/123565453453") { res in
            
            XCTAssertEqual(res.status, .notFound)
            
        }
        
    }
    
    // test update endpoint function
    
    func testUpdateBookUsingValidParams() throws {
        
        let name = "Test_Name"
        let author = "Test_Author"
        
        
        let book = Book(name: name, author: author)
        
        try book.save(on: app.db).wait()
        
        let bookID = book.id!
        
        try app.test(.PUT, "books/\(bookID)", beforeRequest: {
            req in
            
            try req.content.encode([
                "name": "newName",
                "author": "newAuthor",
            ])
            
        }, afterResponse: { res in
            
            let updated = try res.content.decode(Book.self)
            
            XCTAssertEqual(updated.id, bookID)
            XCTAssertEqual(updated.name, "newName")
            XCTAssertEqual(updated.author, "newAuthor")
        })

        
    }
    
    func testUpdateBookUsingInvalidID() throws {
        
        try app.test(.PUT, "books/123542", beforeRequest: {
            req in
            
            try req.content.encode([
                "name": "newName",
                "author": "newAuthor",
            ])
            
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .notFound)
        })
    }
}
