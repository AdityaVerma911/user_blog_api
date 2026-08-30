# User Blog API

A simple RESTful API for a blog application built with Ruby on Rails. The API includes user authentication (signup, login, logout) and post management (CRUD) where users can only manage their own posts.

## Features

- **User Authentication**
  - Sign up new users with email and password (password strength validation)
  - Log in users to establish a session
  - Log out users to end the session
  - Secure password handling using bcrypt
  - Email validation and uniqueness (case-insensitive)

- **Post Management**
  - Create, read, update, and delete posts
  - Users can only manage their own posts (authorization)
  - Post validation: title and body are required

- **Security**
  - Session-based authentication
  - Password strength requirements (8+ characters, uppercase, lowercase, number, special character)
  - Proper error handling and validation messages

## API Endpoints

### Authentication
- `POST /api/v1/signup` - Register a new user
- `POST /api/v1/login` - Log in a user
- `DELETE /api/v1/logout` - Log out a user

### Posts
- `GET /api/v1/posts` - Get all posts for the current user
- `GET /api/v1/posts/:id` - Get a specific post
- `POST /api/v1/posts` - Create a new post
- `PATCH/PUT /api/v1/posts/:id` - Update a post
- `DELETE /api/v1/posts/:id` - Delete a post

## Technical Details

- **Framework**: Ruby on Rails 8.1.3.1
- **Database**: PostgreSQL (for development/test)
- **Testing**: RSpec with Shoulda Matchers and FactoryBot
- **Authentication**: Session-based (cookie-based)
- **Password Security**: bcrypt with strength validation

## Setup

1. Clone the repository
2. Install dependencies: `bundle install`
3. Set up the database: `rails db:create db:migrate`
4. Run the test suite: `bundle exec rspec`

## Testing

The test suite includes:
- Model tests for User and Post (validations, associations)
- Controller tests for authentication (sessions, registrations) and posts
- ApplicationController helper method tests
- FactoryBot fixtures with Faker for realistic test data

Run tests with: `bundle exec rspec`

## License

This project is open source and available under the MIT License.