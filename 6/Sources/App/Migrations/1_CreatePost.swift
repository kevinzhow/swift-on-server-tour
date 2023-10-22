import Fluent 

struct CreatePost: AsyncMigration { 
    func prepare(on database: Database) async throws { 
        try await database.schema(Post.schema)  
            .id() 
            .field("content", .string, .required) 
            .field("created_at", .datetime)
            .create() 
    }

    func revert(on database: Database) async throws { 
        try await database.schema(Post.schema).delete()
    }
}