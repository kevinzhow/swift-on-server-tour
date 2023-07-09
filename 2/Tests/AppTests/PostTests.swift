@testable import App
import XCTVapor

final class PostTests: XCTestCase {
    func testCreateUser() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }

        try await configure(app)
        
        // Auto revert will empty the database and remove the schema
        try await app.autoRevert()
        // Auto migrate will recreate database schema
        try await app.autoMigrate()

        let post = Post(content: "Hello, world!")
        
        try await post.save(on: app.db)

        XCTAssertNotNil(try? post.requireID())
    }
}
