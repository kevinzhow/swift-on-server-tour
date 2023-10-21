import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("users") { posts in
            posts.get(use: index)
            posts.post(use: create)
        }
    }

    func create(req: Request) async throws -> User {
        let postData = try req.content.decode(User.CreateDTO.self)
            
        let user = User(username: postData.username, passwordHash: try await req.password.async.hash(postData.password))
        
        try await user.create(on: req.db)
        
        return user
    }

    func index(req: Request) async throws -> [User] {
        let users = try await User.query(on: req.db).all()
        
        return users
    }
}