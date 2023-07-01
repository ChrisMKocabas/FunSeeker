
# FunSeeker

FunSeeker is a social networking app that allows users to connect with friends, discover fun activities, and share their experiences. With FunSeeker, users can create an account, log in, explore nearby events, and interact with other users (TBI).

Video demo: https://drive.google.com/file/d/1T0MfBMUjuLY7nXVO30KY9gPDJTQp1vIP/view?pli=1

![funseeker](https://github.com/ChrisMKocabas/FunSeeker/assets/75855099/a459af29-db8c-437a-ba51-eff77664c74b)

## Table of Contents
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Features](#features)
  - [Authentication](#authentication)
  - [User Profile](#user-profile)
  - [Events](#events)
- [Technology Stack](#technology-stack)
- [Contributing](#contributing)
- [License](#license)

## Getting Started

These instructions will guide you through setting up the FunSeeker app on your local machine for development and testing purposes.

### Prerequisites

To run FunSeeker, ensure you have the following installed on your machine:

- Xcode
- Cocoapods or Swit Package Manager

### Installation

1. Clone the repository:

git clone https://github.com/your-username/funseeker.git

css
Copy code

2. Navigate to the project directory:

cd funseeker

arduino
Copy code

3. Install dependencies using Cocoapods:

pod install

markdown
Copy code

4. Open `FunSeeker.xcworkspace` in Xcode:

open FunSeeker.xcworkspace

vbnet
Copy code

5. Build and run the app using the Xcode simulator or by connecting a physical device.

## Features

### Authentication

The FunSeeker app provides a seamless authentication flow for users to create an account or log in to an existing one. The authentication flow is handled using Firebase Authentication, which supports various login methods such as email and password, Google Sign-In, and more. The authentication-related code is organized in the following files:

- `AuthenticationView.swift`: A view responsible for handling the authentication flow and rendering the login or signup view based on the user's selection.
- `SignupView.swift`: A view that allows users to sign up by providing their email and password. It also includes form validation and error handling.
- `AuthenticationViewModel.swift`: An observable object that manages the authentication state and performs authentication-related actions, such as signing up, logging in, and handling user sessions.

### User Profile

FunSeeker enables users to manage their profiles and personalize their experience within the app. The user profile functionality includes updating the user's email and password, uploading and displaying a profile picture, and deleting the user account. The user profile-related code is organized in the following files:

- `ProfilePicture.swift`: A Codable struct representing the profile picture model, including the download URL.
- `AuthenticationViewModel.swift`: The existing `AuthenticationViewModel` class is extended with additional methods for updating the user's email and password, uploading and downloading profile pictures, and deleting the user account.

### Events

One of the key features of FunSeeker is the ability to discover and participate in various events. Although the specific code related to events is not provided, you can extend the app by implementing features such as event creation, browsing, joining, and interacting with other participants.

### Technology Stack

FunSeeker is built using a modern tech stack, incorporating the following technologies and frameworks:

- **Architecture**: The app follows the widely adopted Model-View-ViewModel (MVVM) architectural pattern, ensuring a clean separation of concerns and promoting maintainability and testability.

- **SwiftUI**: Apple's declarative UI framework, SwiftUI, is utilized to build the user interface of FunSeeker. With SwiftUI, the app delivers an intuitive and visually appealing user experience across Apple platforms.

- **Firebase**: FunSeeker leverages the power of Firebase, a comprehensive suite of cloud-based tools by Google, to enhance the app's functionality and performance.

  - **Firebase Firestore**: Firestore, Firebase's NoSQL cloud database, serves as the backend for FunSeeker, enabling efficient storage and synchronization of event data.

  - **Firebase Storage**: FunSeeker utilizes Firebase Storage for reliable and scalable storage of event images, ensuring fast and optimized retrieval of images.

- **Offline Mode**: The app incorporates offline capabilities, allowing users to access and interact with certain features and data even when their device is not connected to the internet. This offline mode ensures a seamless user experience regardless of network availability.

- **Geohashing**: FunSeeker implements geohashing techniques to enable location-based features. By using geohashing, the app efficiently indexes and retrieves nearby events based on user location.

- **RESTful APIs**: The app can integrate with external RESTful APIs to fetch data for event recommendations, external service integrations, and other dynamic content retrieval, providing users with up-to-date information and personalized experiences.

- **Custom UI Components**: FunSeeker showcases custom UI implementations to deliver a unique and visually appealing user interface. These custom components include toast notifications, interactive charts for data visualization, and expandable views, creating an engaging and immersive user experience.



## Contributing

We welcome contributions to the FunSeeker app. To contribute, follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them with descriptive commit messages.
4. Push your changes to your forked repository.
5. Submit a pull request to the main repository.

## License

FunSeeker is released under the MIT License. See [LICENSE](./LICENSE) for more details.
