import Fluent
import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) throws {
    app.databases.use(.postgres(configuration: SQLPostgresConfiguration(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database",
        tls: .prefer(try .init(configuration: .clientDefault)))
    ), as: .psql)

    app.migrations.add([CreatePost()])

    app.post("posts") { req async throws -> Post in
        let postData = try req.content.decode(Post.CreateDTO.self)
            
        let post = Post(content: postData.content)
        
        try await post.create(on: req.db)
        
        return post
    }

    app.get("posts") { req async throws -> [Post] in
        let posts = try await Post.query(on: req.db).all()
        
        return posts
    }
}
