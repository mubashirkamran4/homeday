# Use the official Ruby image
FROM ruby:3.1

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  postgresql-client \
  && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Install Bundler and Gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application code
COPY . .

# Expose the necessary port
EXPOSE 3000
