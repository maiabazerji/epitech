# TimeManager App

## Overview
TimeManager is a full-stack web application designed to help users manage their time efficiently. The backend is built with Phoenix, the frontend with Vue.js, and PostgreSQL is used as the database. Docker is used for containerization.

## Technologies Used
- **Backend:** Phoenix
- **Frontend:** Vue.js
- **Database:** PostgreSQL
- **Containerization:** Docker

## Getting Started

### Prerequisites
- Docker
- Docker Compose

### Installation

1. **Clone the repository:**
    ```sh
    git clone https://github.com/maiabazerji/timemanager.git
    cd timemanager
    ```

2. **Set up the environment:**
    Create a `.env` file in the root directory and add the necessary environment variables.

3. **Build and run the containers:**
    ```sh
    docker-compose up --build
    ```

4. **Run database migrations:**
    ```sh
    docker-compose exec backend mix ecto.migrate
    ```

5. **Access the application:**
    - Backend: `http://localhost:4000`
    - Frontend: `http://localhost:8080`

## Usage
- Register and log in to start managing your time.
- Create, edit, and delete tasks.
- Track your progress and manage your schedule.

## Contributing
Contributions are welcome! Please fork the repository and create a pull request.

## License
This project is licensed under the MIT License.

## Contact
For any inquiries, please contact [your email].
