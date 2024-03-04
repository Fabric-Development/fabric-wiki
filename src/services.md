# What's a Services?

Services are some kind of "data servers", it's just a normal object that has properties and methods, it differs when it comes to properties though..

When one property of a service gets updated/changed , the service will emit a signal that users can connect to so they get notified with the changes

Services follow a paradigm called the ["observer pattern"](https://en.wikipedia.org/wiki/Observer_pattern), thus it's a class that when it gets initialized it starts doing a _task_ in the background while your code is executing, it shouldn't be blocking the main thread, users can connect to these objects so they get notified when a signal of that class object get emitted or if a property gets changed
