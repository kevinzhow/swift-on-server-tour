import Vapor

let app = Application()

app.http.server.configuration.port = 8080

defer { app.shutdown() }

app.get { req async in
    "It works!"
}

try app.run()