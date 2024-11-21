# RideShare

RideShare is a mobile application built using **Flutter** and **OpenStreetMap** that allows users to share rides. The app enables drivers to post available rides and passengers to join rides going in the same direction, promoting convenient and eco-friendly travel.

---

## Features

- **User Registration/Login**: Secure sign-up and login functionality.
- **Join a Ride**: Easily search and join available rides in your area.
- **Post a Ride**: Drivers can post available rides with details such as starting point, destination, and time.
- **Real-Map Ride**: choose rides in map with **OpenStreetMap** integration.
- **Rating System**: Rate your experience after the ride.

---

## Tech Stack

- **Flutter**: Frontend framework for creating a responsive mobile UI.
- **GetX**: State management and navigation.
- **OpenStreetMap (OSM)**: Map integration for showing ride routes and real-time location tracking.
- **Node.js/Express**: Backend server to handle API requests.
- **MongoDB**: Database for storing user data, ride information, and ride history.

---

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine.

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Node.js and npm: [Install Node.js](https://nodejs.org/en/download/)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/ihebowski/rideshare.git
   cd rideshare
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Install backend dependencies**:
   Navigate to the `backend` folder (or wherever your Node.js server is located) and run:
   ```bash
   npm install
   ```

4. **Set up environment variables**:
   Create a `.env` file in the backend folder with your environment-specific variables (e.g., database connection string).

5. **Run the backend server**:
   ```bash
   npm start
   ```

6. **Run the app**:
   ```bash
   flutter run
   ```

---

## Project Structure (Frontend)

```bash
lib/
│
├── main.dart                   # Main entry point of the application
├── routes.dart                 # Routes for navigation
├── controllers/                # GetX controllers for state management
│   ├── auth_controller.dart    # Authentication logic
│   └── ride_controller.dart    # Ride-related logic
├── views/                      # UI screens
│   ├── widgets/                # Reusable widgets
│   │   └── ride_card.dart
│   ├── login_view.dart         # Authentication views
│   └── choose_ride_view.dart    # Ride-related views
├── models/                     # Data models
│   └── ride_model.dart
├── services/                   # API services
│   └── ride_service.dart

```

## Project Structure (Backend)

```bash
```

---

## API Endpoints

Below are the primary API endpoints for the app:

- **User Registration**: `POST /api/users/register`
- **User Login**: `POST /api/users/login`
- **Post a Ride**: `POST /api/rides/create`
- **Join a Ride**: `POST /api/rides/join`
- **Get All Rides**: `GET /api/rides/fetch-drivers`

---

## Author

- **Iheb Barrah**  
  *Flutter Developer & IT Engineering Student at TEK-UP*

Feel free to reach out at [iheb.barrah@gmail.com](mailto:iheb.barrah@gmail.com) or visit my [LinkedIn](https://www.linkedin.com/in/iheb-barrah).


- **Azyz Mejry**  
  *NodeJS Developer & IT Engineering Student at TEK-UP*

Feel free to reach out at [azzizzflash@gmail.com](mailto:azzizzflash@gmail.com) or visit my [LinkedIn](https://www.linkedin.com/in/).

---

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/ihebowski/rideshare/issues).

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
