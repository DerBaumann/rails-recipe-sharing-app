# SocialChef - Recipe Sharing App

SocialChef is a collaborative web application for creating, sharing, rating, and managing recipes.

> The detailed project documentation (problem statement, vision, ERM, breadboards, locking/transactions, and test results) can be found in the [`/docs`](docs/) directory.

## Tech Stack

- **Language / Framework:** Ruby / Ruby on Rails
- **Database:** SQLite3
- **Frontend:** ERB, Tailwind, DaisyUI, Turbo & Stimulus (Hotwire)
- **Authorization:** Pundit
- **Testing:** Minitest / RSpec

## Prerequisites

Ensure the following components are installed on your system:

- Ruby 4.0.6
- Rails 8.1
- Bundler (`gem install bundler`)
- Git
- SQLite3

If you use `mise` you can just run the following:

```sh
mise use -g ruby@4.0.6
gem install rails
```


## Installation & Configuration

Follow these steps in your terminal to set up the application from a fresh clone:

```sh
git clone https://github.com/DerBaumann/rails-recipe-sharing-app.git
cd rails-recipe-sharing-app
rails db:create
rails db:migrate
rails db:seed
bin/dev # Starts dev server. Required for tailwind
```

The application will then be accessible in your browser at http://localhost:3000.