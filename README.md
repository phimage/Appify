# Appify

Generate simple macOS `.app` from Swift Package `.executable`.

Could be useful for status bar app based only on Swift Package Manager.

## How to

### Add Appify in your Package.swift

```swift
let package = Package(
    name: "my-executable",
    platforms: [.macOS(.v11)],
    products: [
        .executable(name: "my-executable", targets: ["Executable"])
    ],
    dependencies: [
        .package(url: "https://github.com/phimage/appify.git", from: "0.0.1")
    ],
    targets: [
        .target(
        name: "Executable",
            dependencies: ["Appify", ...]
        )
    ],
    ...
)
```

### Add code in your executable

In `main.swift` just add one line before your app starting code


```swift

Appify.run() // here the code, will exit app if the first command line argument is appify

// your app code
let app: NSApplication = .shared
app.delegate = xxx
app.run()

```

then you could run

```bash
my-executable appify
```

A `my-executable.app` will be created near the `my-exectable`

## Improvements

- [ ] Create plist files with many input from command line parameters or configuration file.
    - [ ] App icon
    - [ ] Status bar app or not

