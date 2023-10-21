import Fluent
import Vapor

struct PostController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.group("posts") { posts in
            posts.get(use: index)
            posts.post(use: create)
        }
    }

    func create(req: Request) async throws -> Post {
        let postData = try req.content.decode(Post.CreateDTO.self)
            
        let post = Post(content: postData.content)
        
        try await post.create(on: req.db)
        
        return post
    }

    func index(req: Request) async throws -> [Post] {
        let posts = try await Post.query(on: req.db).all()
        
        return posts
    }
}