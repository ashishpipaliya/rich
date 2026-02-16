# Rich - Flutter Clean Architecture - A Hands-on Learning Project

This project is a hands-on implementation of Clean Architecture principles in Flutter. It is designed for learning purposes, demonstrating how to build a scalable, testable, and maintainable mobile application using modern industrial standards.

## Project Overview
The application consumes a remote E-commerce Dashboard API and displays it using a modular, feature-based structure. It emphasizes the separation of concerns, ensuring that business logic is isolated from UI and external data sources.

## Clean Architecture Layers

Clean Architecture divides the application into distinct layers to manage complexity and dependencies.

### 1. Presentation Layer
Located in `lib/features/[feature_name]/presentation/`.
This layer is responsible for the UI and state management.
- **Bloc/Providers**: Handles business logic and UI state transitions.
- **Pages/Widgets**: Pure UI components that listen to state changes.

### 2. Data Layer
Located in `lib/features/[feature_name]/data/`.
This layer handles the "How" of data retrieval.
- **Models**: Data transfer objects (DTOs) that represent the JSON structure of an API. In this project, we utilize a Unified Model approach where Entities and Models coexist in a single class to reduce boilerplate while maintaining structure.
- **Data Sources**: Low-level implementation of network calls (Retrofit/Dio) or local storage.
- **Repositories (Implementation)**: Coordinates data from multiple sources and returns them to the Presentation layer.

## Pragmatic Implementation Implementation
While strict Clean Architecture requires significant boilerplate (manual mapping between Models and Entities, mandatory UseCases for every action), this project adopts a **Pragmatic Clean Architecture** approach to accelerate development:
- **Unified Schema**: Models use JSON annotations and reside in the data layer to avoid redundant mapping extensions.
- **Simplified Flow**: UseCases are omitted; the Bloc interacts directly with the Repository.

## Tech Stack
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Networking**: [Retrofit](https://pub.dev/packages/retrofit) & [Dio](https://pub.dev/packages/dio)
- **Dependency Injection**: [Injectable](https://pub.dev/packages/injectable) & [GetIt](https://pub.dev/packages/get_it)
- **Data Handling**: [Freezed](https://pub.dev/packages/freezed) & [JSON Serializable](https://pub.dev/packages/json_serializable)
- **Functional Programming**: [fpdart](https://pub.dev/packages/fpdart) (Either for error handling)

## Getting Started
To run this project:
1. Ensure you have the Flutter SDK installed.
2. Clone the repository.
3. Run `flutter pub get`.
4. Run `dart run build_runner build -d` to generate necessary code for DI and JSON serialization.
5. Execute `flutter run`.

This project serves as a template for those looking to understand how to bridge the gap between architectural theory and real-world development deadlines.
