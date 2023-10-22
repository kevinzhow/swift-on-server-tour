import Vapor
import Fluent

final class Post: Model, Content {
    static let schema = "posts"

    @ID(key: .id)
    var id: UUID?

    @OptionalParent(key: "user_id")
    var user: User?

    @Field(key: "content")
    var content: String
    
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