@testable import App
import XCTVapor

final class UserTests: XCTestCase {
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
    
    func testCreateUser() async throws {
        let userData = User.CreateDTO(username: "happyuser", password: "123456")
        try app.test(.POST, "users", beforeRequest: { req in
            try req.content.encode(userData)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let user = try res.content.decode(User.self)
            
            XCTAssertEqual(user.username, userData.username)
            XCTAssertTrue(try app.password.verify("123456", created: user.passwordHash))
        })
    }
    
    func testGetUsers() async throws {
        let user = User(username: "hellouser", passwordHash: try await app.password.async.hash("123456"))
        try await user.save(on: app.db)
        try app.test(.GET, "users", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            
            let users = try res.content.decode([User].self)
            
            XCTAssertEqual(users.count, 1)
            XCTAssertEqual(users[0].username, user.username)
        })
    }
}