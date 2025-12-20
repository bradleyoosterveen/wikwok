## General code readability

When reviewing code, prioritize clarity and consistency. Specifically:
- Ensure all widgets are returned from either a `StatelessWidget` or `StatefulWidget`.
- For any file or class, follow a "define, then use" approach: Define all variables, methods, and properties at the top, and for `StatelessWidget`s or `StatefulWidget`s place the build method at the end of the class.

## Dart

This repository uses Dart 3.10, which introduces:

### Dot shorthands.
This new feature lets you omit redundant class or enum names when the compiler can infer the type from the context. You can also use them with constructors, static methods, and static fields.

Example: 

```dart
enum LogLevel { info, warning, error, debug }

void logMessage(String message, {LogLevel level = .info}) {
  // ... implementation
}

// Somewhere else in your app
logMessage('Failed to connect to database', level: .error);
```