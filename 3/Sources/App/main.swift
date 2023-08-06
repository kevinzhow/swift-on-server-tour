import Vapor
import Fluent
import FluentPostgresDriver

let app = Application(.development)

app.http.server.configuration.port = 8080

defer { app.shutdown() }

app.get { req async in
    "It works!"
}

try configure(app)

try app.run()
