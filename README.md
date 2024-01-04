# SwiftLingo
Localization is time-consuming so I made a package to automate the task.

## Steps to setup, only take a few minutes!
1. Import the pacakge `https://github.com/kumarneel/SwiftLingo`
2. Setup a folder where you would like to store your localized information
  - Create a `.swift` file called `LocalizableStrings`
  - Create a `.string` file called `Localizable`, Xcode will automatically call it by this name

     <img width="258" alt="Screenshot 2023-12-15 at 1 14 05 PM" src="https://github.com/kumarneel/SwiftLingo/assets/19336901/33c1dbee-1a62-43f3-ba42-90e00d74acf9">

  
3. Go to Project Settings tab `Info`
  - Go to the Localization Section
<img width="1789" alt="Screenshot 2023-12-15 at 1 15 46 PM" src="https://github.com/kumarneel/SwiftLingo/assets/19336901/a67b11e1-3994-4033-9eaf-b621c77f671b">


4. Click `+` and add any Language that you would like to translate into
  - NOTE, these language codes are important and will passed into SwiftPackage Initializer
<img width="677" alt="Screenshot 2023-12-15 at 1 18 39 PM" src="https://github.com/kumarneel/SwiftLingo/assets/19336901/3691106a-99a5-4b42-909d-b531b7e5040e">

5. Go back to your `Localizable.strings` file. Go to the navigation tab on the right and click **Localize...**
<img width="1792" alt="Screenshot 2023-12-15 at 1 22 24 PM" src="https://github.com/kumarneel/SwiftLingo/assets/19336901/85feca07-6646-4dda-823a-8828da6d5187">

6. Check the languages you just added to be localized
<img width="260" alt="Screenshot 2023-12-15 at 1 23 10 PM" src="https://github.com/kumarneel/SwiftLingo/assets/19336901/318261d0-376f-46a3-b18a-b1569c48823b">

7. They will now appear under the file you have created
<img width="274" alt="Screenshot 2023-12-15 at 1 23 40 PM" src="https://github.com/kumarneel/SwiftLingo/assets/19336901/e679be35-045e-411c-adb0-feacb35fed2f">

## Usage

### Create your first key in your English Translation file
```
"log_in_title" = "Login";
```

### Import SwiftLingo
### Initialize in AppDelegate or anywhere AND RUN ON SIMULATOR
```
// Path to root directory where files are stored
// 'fr' is the French Language Code
SL.initialize(
    directoryPath: "/Users/photos/Desktop/Localization/SwiftLingoTest/SwiftLingoTest/Localization",
    desiredLanguages: ["en", fr"],
    openAPIKey: "your_API_KEY"
)
```
### Watch as files auto-populate once logs are complete

![Screenshot 2023-12-15 at 3 11 55 PM](https://github.com/kumarneel/SwiftLingo/assets/19336901/9388446c-ce00-46f5-aaa5-cb1a4dbc2319)

### Use localized string variable in View

```
struct ContentView: View {
    var body: some View {
        VStack {
            Text(LocalizableStrings.log_in_title)
        }
        .padding()
    }
}
```



