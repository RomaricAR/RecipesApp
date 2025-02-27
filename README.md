# RecipesApp

A SwiftUI-based recipe application that fetches and displays recipes using TheMealDB API, with Core Data for caching and Kingfisher for image loading.

## Requirements

- **Xcode 14.0** or later
- **iOS 15.0** or later
- **Swift 5.6** or later

## Getting Started

### Building the Project

1. **Clone the repository:**
    ```sh
    git clone https://github.com/RomaricAR/RecipesApp.git
    ```
2. **Open the project in Xcode:**
    ```sh
    cd RecipesApp
    open Recipes.xcodeproj
    ```
3. **Build the project:**
   - Select your target device or simulator.
   - Press `Cmd + R` or click the "Run" button in Xcode.

### Running Tests

Unit tests are provided in the `RecipesTests` target. To run the tests:

1. **Open the test navigator:**
   - In Xcode, press `Cmd + 6` or click the "Test Navigator" icon.
2. **Run the tests:**
   - Press `Cmd + U` or click the "Run" button next to `RecipesTests`.

### Folder Structure Explanation

- **Models:** Contains the data models used in the app, such as `Recipe`, `RecipeDetailsModel`, and Core Data entities like `CachedDetails` and `CachedRecipe`.
- **ViewModels:** Contains the ViewModel classes (`RecipesViewModel`, `RecipeDetailsViewModel`) that manage data fetching, business logic, and integration with Core Data for caching.
- **Views:** Contains SwiftUI views (`RecipesView`, `RecipeDetailsView`) that define the app's user interface.
- **Services:** Contains the networking service responsible for fetching data from the API, including `NetworkService`, `NetworkServiceProtocol`, and related endpoints.
- **Utilities:** Contains utility files, extensions, error handling logic, and the `CoreDataManager` for managing Core Data operations.
- **RecipesTests:** Contains unit tests for the app, including mock services for testing networking and Core Data interactions.
- **RecipesUITests:** Contains UI tests for verifying the app's user interface behavior.

## Dependencies

- **Kingfisher (8.2.0):** Used for efficient image loading and caching in the app.
- **SwiftLintPlugins (0.58.2):** Used for code linting and maintaining code quality.

## API Reference

This app uses the [TheMealDB API](https://www.themealdb.com/api.php). The following endpoints are utilized:

- **Fetch Recipes:** `https://www.themealdb.com/api/json/v1/1/filter.php?c=Dessert`
- **Fetch Recipe Details:** `https://www.themealdb.com/api/json/v1/1/lookup.php?i={MEAL_ID}`

## Additional Notes

- The app uses Core Data for caching recipe details (`CachedDetails` and `CachedRecipe` entities) to improve performance and offline access.
- Ensure you have an active internet connection to fetch recipes from TheMealDB API initially, as cached data will be used subsequently.
