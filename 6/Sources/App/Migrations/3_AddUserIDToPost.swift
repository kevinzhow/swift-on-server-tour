import Fluent 

struct AddUserIDToPost: AsyncMigration { 
    func prepare(on database: Database) async throws { 
        try await database.schema(Post.schema)  
            .field("user_id", .uuid, .references(User.schema, "id")) 
            .update()
    }

    func revert(on database: Database) async throws { 
       try await database.schema(Post.schema)
          .deleteField("user_id")
          .update()
    }
}