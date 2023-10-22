@testable import App
import XCTVapor

final class PostTests: XCTestCase {
    var app: Application!

    override func setUp() async throws {
        app = Application(.testing)
        try configure(app)

        try await app.autoRevert()
        try await app.autoMigrate()
    }

    
    override func tearDown() async throws {
        app.shutdown()
    }
    

    func testCreatePost() async throws {
        let user = User(username: "hellouser", passwordHash: try await app.password.async.hash("123456"))
        try await user.save(on: app.db)
        let postDTO = Post.CreateDTO(content: "Post created from test")

        try app.test(.POST, "posts", beforeRequest: { req in
            try req.content.encode(postDTO)
            req.headers.basicAuthorization = BasicAuthorization(username: user.username, password: "123456")
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let post = try res.content.decode(Post.self)
            
            XCTAssertEqual(postDTO.content, post.content)
            XCTAssertEqual(try user.requireID(), post.$user.id)
        })
    }
}
