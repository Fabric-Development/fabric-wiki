# What's a Services?
Services are kind of "data servers" for Fabric. They have methods and properties like normal objects, but signals are emitted when a property of a service gets changed. Other programs and users can connect to these signals so that they get notified when changes happen.

Services follow a paradigm called the [observer pattern](https://en.wikipedia.org/wiki/Observer_pattern), so it starts doing a task in the background while your code is executing and doesn't block the main thread. Users can connect to these services to be notified of changes in properties.
