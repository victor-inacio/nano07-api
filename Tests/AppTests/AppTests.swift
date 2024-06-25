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
    
    //Test delete endpoimt  funtion
    
    // test update endpoint function
}
