# Flutter Code Conventions

## Code Style
- **Indentation**: Use 2 spaces for indentation.
- **Variable and Function Naming Rules**:
  - **Variable Names**: Use camelCase. Example: `userId`
  - **Function Names**: Start with a verb to clearly convey meaning. Example: `writeUserData()`
  - **Constants**: Use uppercase letters and underscores. Example: `MAX_HEIGHT`
- **Widget and Class Naming Rules**:
  - Use PascalCase for all class and widget names. Example: `UserData`
  - Widget classes should be named to clearly reflect their roles. Example: `UserCard`
- **Commenting**: Use `///` for concise explanations where needed.
- **Debugging**: For debugging purposes, use debugPrint instead of print.

## File and Folder Structure
- **Folder Structure**:
  - `lib/src/pages`: Widgets related to screens and pages
  - `lib/src/view_models`: Logic related to ViewModels
  - `lib/src/services`: Services and API-related code
  - `lib/src/components`: Reusable components
  - `lib/src/utils`: Utility functions and helper classes
- **File Names**: Use lowercase letters and underscores for all file names. Example: `login_view_model.dart`

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
  - Note: All commit messages should be written in lowercase.
  - Example: `feat: add user profile page`

## Widget Development Guidelines
- **Widget Lifecycle Management**:
  - Use `initState` and `dispose` only when necessary and avoid excessive processing or resource usage.
  - Call `setState` to update the UI when the state changes.
- **Builder and Layout Guidelines**:
  - To avoid complexity in the `build` method, split complex widgets into separate widgets.
  - Use `Column`, `Row`, `Stack`, and other layout widgets appropriately for a clean layout.

## Theme and Styling
- **Colors and Styles**: Manage all colors and text styles within the `theme` to maintain consistency.
- **TextStyle**:
  - Define styles for titles, body text, etc., using the `TextStyle` class within the theme.
  - Example: `Theme.of(context).textTheme.headline6`
