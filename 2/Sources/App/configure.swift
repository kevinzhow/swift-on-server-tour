import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) throws {
    app.databases.use(.postgres(configuration: SQLPostgresConfiguration(
        hostname: "localhost",
        port: 5432,
        username: "vapor_username",
        password: "vapor_password",
        database: "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    app.migrations.add([CreatePost()])
}
