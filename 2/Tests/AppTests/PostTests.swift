@testable import App
import XCTVapor

final class PostTests: XCTestCase {
    func testCreatePost() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }

        try configure(app)
        
        // autoRevert 将自动执行所有 Migration 中 revert 的内容
        try await app.autoRevert()
        // autoMigrate 将自动执行所有 Migration 中 prepare 的内容
        // 这两步将重建我们的数据库，为我们提供一个干净的测试环境
        try await app.autoMigrate()

        let post = Post(content: "Hello, world!")
        
        try await post.save(on: app.db)

        let postID = try? post.requireID()
        // 如果 postID 不为 nil 则成功创建，测试通过
        XCTAssertNotNil(postID)
    }
}
