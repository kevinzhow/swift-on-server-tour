import Fluent 

struct CreateUser: AsyncMigration { 
    func prepare(on database: Database) async throws { 
        try await database.schema(User.schema)  
            .id()  
            .field("username", .string, .required)
            .field("password_hash", .string, .required)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws { 
        try await database.schema(User.schema).delete() 
    }
}