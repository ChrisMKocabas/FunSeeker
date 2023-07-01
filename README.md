
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

One of the key features of FunSeeker is the ability to discover and participate in various events. The Events section offers a rich set of features to enhance your event browsing and participation experience. Here are some of the cool features:

1. **Event Discovery**: FunSeeker allows you to easily discover a wide range of events happening in your area or any desired location. You can explore events across different categories, including music concerts, sports matches, art exhibitions, theater shows, and more.

2. **Event Filtering**: To help you find events that match your preferences, FunSeeker provides powerful filtering options. You can filter events based on criteria such as date, distance, category, price range, and more. This allows you to narrow down the event options and focus on the ones that interest you the most.

3. **Interactive Event Cards**: Each event is presented in a visually appealing and interactive event card. The card provides essential details about the event, such as the event name, date, venue, pricing, and distance. You can click on an event card to view more detailed information about the event.

4. **Countdown Timer**: FunSeeker displays a countdown timer for each event, indicating the time remaining until the event starts. This feature allows you to stay updated on upcoming events and plan your schedule accordingly.

5. **Event Images**: Event cards feature high-quality images that provide a glimpse of the event. You can see the event venue, performers, artwork, or any other relevant visuals associated with the event. These images help create a captivating preview of the event.

6. **Offline Access**: FunSeeker offers offline access to previously browsed events. If you lose internet connectivity or want to access event information while offline, you can still view the events you have previously explored.

7. **Sorting Options**: You can sort events based on different criteria such as date, distance, or the start of ticket sales. This feature enables you to prioritize events based on your preferences and easily find the events that align with your interests.

8. **Search and Autocomplete**: FunSeeker includes a search functionality that allows you to search for specific events or event categories. As you type, the app provides autocomplete suggestions, making it easier and faster to find the events you are looking for.

9. **Save and Favorite Events**: You can save events to your personal list and mark them as favorites. This feature lets you keep track of events you are interested in, making it convenient to access them later or receive updates about them.

10. **Interactive Map View**: FunSeeker provides an interactive map view that allows you to visualize events based on their location. You can explore events on the map, see their proximity to your current location, and plan your event itinerary accordingly.

11. **Social Interaction**: FunSeeker facilitates social interaction among event participants. You can connect with other attendees, share your experiences, and discuss the events through built-in social features such as event chat rooms or comments sections.

12. **Event Creation and Participation**: FunSeeker allows event organizers to create and promote their events on the platform. As a user, you can participate in events by purchasing tickets, RSVPing, or taking other relevant actions based on the event's requirements.

These features make the Events section of FunSeeker a comprehensive and immersive platform for discovering, exploring, and engaging with various events. Whether you are a music enthusiast, sports fan, art lover, or simply looking for exciting experiences, FunSeeker's Events section has something for everyone.

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
