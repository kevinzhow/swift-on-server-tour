import Fluent 

// 定义 CreatePost 结构体，实现 AsyncMigration 协议
struct CreatePost: AsyncMigration { 
    // 准备方法，在数据库上进行准备操作
    func prepare(on database: Database) async throws { 
        // 创建 Post 表的数据库模式对象
        try await database.schema(Post.schema)  
            .id()  // 添加 id 列
            .field("content", .string, .required)  // 添加 content 列，类型为字符串，不能为空
            .field("created_at", .datetime)  // 添加 created_at 列，类型为日期时间
            .create()  // 创建 Post 表
    }

    // 回滚方法，在数据库上进行回滚操作
    func revert(on database: Database) async throws { 
        try await database.schema(Post.schema).delete()  // 删除 Post 表的数据库模式对象
    }
}