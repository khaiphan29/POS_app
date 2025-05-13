# POS_app

POS_app is a modern Point of Sale (POS) application designed to manage store operations efficiently. The application includes features like order management, inventory control, and real-time updates, all wrapped in a user-friendly interface.

## Features

- **Order Management**: 
  - Create, edit, and delete orders.
  - Manage item quantities within orders.
  - Track the status of orders (e.g., Pending, Completed, Canceled).

- **Real-time Updates**: 
  - WebSocket integration for real-time synchronization of order details and inventory changes.

- **Progressive Web App (PWA)**:
  - Mobile-friendly interface with offline capabilities.
  - Customizable app manifest for standalone usage.

- **Admin and Staff Access**:
  - Role-based access control to secure sensitive features.
  - Authentication required for all users.

- **Service Worker**:
  - Support for web push notifications to enhance user engagement.

## Tech Stack

- **Frontend**: JavaScript, StimulusJS
- **Backend**: Ruby on Rails
- **Database**: PostgreSQL
- **WebSocket**: ActionCable

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/khaiphan29/POS_app.git
   cd POS_app
   ```

2. Install dependencies:
   ```bash
   bundle install
   yarn install
   ```

3. Set up the database:
   ```bash
   rails db:create
   rails db:migrate
   ```

4. Start the server:
   ```bash
   rails server
   ```

5. Access the application at `http://localhost:3000`.

## Usage

- **Order Management**:
  - Navigate to the Orders page to view and manage orders.
  - Use the inline editing feature to adjust item quantities or remove items.

- **Real-time Features**:
  - Ensure WebSocket is enabled to experience live updates across clients.

