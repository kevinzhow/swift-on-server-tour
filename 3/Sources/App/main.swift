import Vapor
import Fluent
import FluentPostgresDriver

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)

let app = Application(env)

app.http.server.configuration.port = 8080

defer { app.shutdown() }

app.get { req async in
    "It works!"
}

try configure(app)

try app.run()