# SwiftLingo
Localization is time-consuming so I made a package to automate the task.

## Steps to setup, only take a few minutes!
1. Import the pacakge `https://github.com/kumarneel/SwiftLingo`
2. Setup a folder `Localizable` called where you would like to store your localized information
  - Create a `.swift` file called `LocalizableStrings`
  - Create a `.xcstrings` file called `Localizable`, Xcode will automatically call it by this name

     <img width="258" alt="Screenshot 2023-12-15 at 1 14 05 PM" src="https://github.com/kumarneel/SwiftLingo/assets/19336901/10175567-4d55-4802-ab51-2b9f6634dc19">


  
3. Go to Project Settings tab `Info`
  - Go to the Localization Section
<img width="1789" alt="Screenshot 2023-12-15 at 1 15 46 PM" src="https://github.com/kumarneel/SwiftLingo/assets/19336901/a67b11e1-3994-4033-9eaf-b621c77f671b">


4. Click `+` and add any Language that you would like to translate into
  - NOTE, these language codes are important and will passed into SwiftPackage Initializer
<img width="677" alt="Screenshot 2023-12-15 at 1 18 39 PM" src="https://github.com/kumarneel/SwiftLingo/assets/19336901/3691106a-99a5-4b42-909d-b531b7e5040e">

5. Go back to your `Localizable.xcstrings` file. The new language will automatically appear next to English
<img width="1792" alt="Screenshot 2023-12-15 at 1 22 24 PM" src="https://github.com/kumarneel/SwiftLingo/assets/19336901/93be851a-d9a6-4e66-8a49-1e2c35b4dfd7">

## Usage

### Create your first key in your English Translation file

```
"log_in_title" = "Login";
```
![Screenshot 2024-01-10 at 4 44 45 PM](https://github.com/kumarneel/SwiftLingo/assets/19336901/fbd72e96-927d-4bdf-93bb-f0242528be2f)



### Import SPM SwiftLingo Package
### Initialize in AppDelegate or anywhere AND RUN ON SIMULATOR
```

// 'fr' is the French Language Code
SL.initialize(
    // Path to the root directory where files are stored
    directoryPath: "/Users/photos/Desktop/Localization/SwiftLingoTest/SwiftLingoTest/Localization",
    desiredLanguages: ["en", "fr"],
    openAPIKey: "your_API_KEY"
)
```
### Watch as files auto-populate once logs are complete

![Screenshot 2024-01-10 at 4 50 20 PM](https://github.com/kumarneel/SwiftLingo/assets/19336901/27d7c070-6c9d-4ad9-b909-5e7616128dc7)


### Use localized string variable in View

```
import SwiftUI
import SwiftLingo

struct ContentView: View {
    var body: some View {
        VStack {
            Text(LocalizableStrings.log_in_title)
        }
        .padding()
        .onAppear {
            SL.initialize(
                directoryPath: "/Users/photos/Desktop/RE/TestSwiftLingo/TestSwiftLingo/Localizable",
                desiredLanguages: ["en", "fr"],
                openAPIKey: "YOUR_API_KEY"
            )
        }
    }
}

#Preview {
    ContentView()
}

```



