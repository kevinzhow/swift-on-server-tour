import Vapor
import Fluent
import FluentPostgresDriver

let app = Application()

app.http.server.configuration.port = 8080

defer { app.shutdown() }

app.get { req async in
    "It works!"
}

try await configure(app)

try app.run()