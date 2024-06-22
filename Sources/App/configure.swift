import Vapor
import Fluent
import FluentMySQLDriver

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    var tls = TLSConfiguration.makeClientConfiguration()
    tls.certificateVerification = .none
    
    app.databases.use(.mysql(
        hostname: "localhost", 
        username: "root", 
        password: "mysqlPW", 
        database: "bookDB",
        tlsConfiguration: tls
    ),as: .mysql)
    
    app.migrations.add(CreateBook())
    try await app.autoMigrate()
    
    //Register routes
    try routes(app)
}
