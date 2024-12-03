# Flutter Code Conventions

## Code Style
- **Indentation**: Use 2 spaces for indentation.
- **Variable and Function Naming Rules**:
  - **Variable Names**: Use camelCase. Example: `userId`
  - **Function Names**: Start with a verb to clearly convey meaning. Example: `writeUserData()`
  - **Constants**: Use uppercase letters and underscores. Example: `MAX_HEIGHT`
- **Widget and Class Naming Rules**:
  - Use PascalCase for all class and widget names. Example: `UserData`
  - Widget classes should be named to clearly reflect their roles. Example: `LoadingIndicator`
- **Commenting**: Use `///` for concise explanations where needed.
- **Debugging**: For debugging purposes, use `debugPrint` instead of `print`.

## File and Folder Structure

### Folder Structure
- **Purpose**: Each folder serves a clear and specific purpose.
  - `lib/src/pages`: Contains UI code for full screens or pages (e.g., `HomePage`, `ProfilePage`).
  - `lib/src/view_models`: Manages the business logic and state for specific features (e.g., `LoginViewModel`, `ProgressViewModel`).
  - `lib/src/models`: Data structures and entities that represent application data (e.g., `UserData`, `QuestionData`).
  - `lib/src/services`: Manages external or internal API calls, Firebase integrations, and database interactions (e.g., `DatabaseService`, `FirebaseAuthData`).
  - `lib/src/components`: Reusable widgets or UI components shared across the app (e.g., `LoadingIndicator`, `CommonListTile`).
  - `lib/src/utils`: Helper functions and utilities for common functionalities (e.g., `ToastMessage`, `ScrollHandler`).

### File Naming
- Use lowercase letters and underscores for file names. Example: `login_view_model.dart`.

### Widget Organization
- Widgets related to a specific feature or page should be nested within a corresponding subfolder for clarity.
  - Example: `src/components/question_detail_widgets/contents` for question detail-related widgets.

### Naming Consistency
- Each widget or component should clearly indicate its function in its name.
  - Example: `RankingWidget` for ranking-related features.

## Git Commit Message Style

- **Commit Message Format**: `<type>: <description>`
  - `feat`: Adding new features
  - `fix`: Fixing bugs
  - `refactor`: Code refactoring
  - `style`: Code style changes (no functional changes)
  - `chore`: Miscellaneous changes
  - `rename`: Renaming files or folders
  - `remove`: Deleting files only
  - `design`: Modifying the UI design
  - `docs`: Document changes
  - `merge`: Merge branches
  - **Note**: All commit messages should be written in lowercase.
  - **Example**: `feat: add user profile page`

## Widget Development Guidelines

### Widget Lifecycle Management
- Use `initState` and `dispose` only when necessary and avoid excessive processing or resource usage.
- Call `setState` to update the UI when the state changes.

### Builder and Layout Guidelines
- To avoid complexity in the `build` method, split complex widgets into separate widgets.
- Use `Column`, `Row`, `Stack`, and other layout widgets appropriately for a clean layout.

## Theme and Styling

- **Colors and Styles**:
  - Manage all colors and text styles within the `theme` to maintain consistency.
- **TextStyle**:
  - Define styles for titles, body text, etc., using the `TextStyle` class within the theme.
  - Example: `Theme.of(context).textTheme.headline6`.
