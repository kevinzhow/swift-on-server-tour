@testable import App
import XCTVapor

final class PostTests: XCTestCase {
    func testCreatePost() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }

        try configure(app)
        
        try await app.autoRevert()
        try await app.autoMigrate()

        let postDTO = Post.CreateDTO(content: "Post created from test")

        try app.test(.POST, "posts", beforeRequest: { req in
            try req.content.encode(postDTO)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let post = try res.content.decode(Post.self)
            
            XCTAssertEqual(postDTO.content, post.content)
        })
    }
}
