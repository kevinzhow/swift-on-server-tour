import Vapor
import Fluent

final class Post: Model, Content {
    // 数据库中的表名
    static let schema = "posts"

    // 唯一性标识符
    @ID(key: .id)
    var id: UUID?

    // 内容
    @Field(key: "content")
    var content: String

    // 创建时间
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, content: String) {
        self.id = id
        self.content = content
    }
}

extension Post {
    struct CreateDTO: Content {
        let content: String
    }
}