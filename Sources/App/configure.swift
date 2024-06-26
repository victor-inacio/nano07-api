import Vapor
import Fluent
import FluentMySQLDriver
import FluentSQLiteDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    var tls = TLSConfiguration.makeClientConfiguration()
    tls.certificateVerification = .none
    
    if (app.environment == .testing) {
        app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    } else {
        app.databases.use(.mysql(
            hostname: "localhost",
            username: "root",
            password: "mysqlPW",
            database: "bookDB",
            tlsConfiguration: tls
        ),as: .mysql)
    }
    
    app.migrations.add(CreateBook())
    
    try app.autoMigrate().wait()
   
    
    
    //Register routes
    try routes(app)
}
