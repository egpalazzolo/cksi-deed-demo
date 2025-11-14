#!/bin/bash
set -e

# -----------------------------
# Configuration - adjust if needed
# -----------------------------
RUBY_VERSION="2.7.6"
BUNDLER_VERSION="2.1.4"

# -----------------------------
# 1. Uninstall newer Rubies (RVM)
# -----------------------------
if command -v rvm >/dev/null 2>&1; then
    echo "Checking installed Rubies via RVM..."
    rvm list
    # Example: uninstall Rubies > 2.7
    rvm uninstall 3.0 || true
    rvm uninstall 3.1 || true
    rvm uninstall 3.2 || true
fi

# -----------------------------
# 2. Install / switch to original Ruby
# -----------------------------
if command -v rvm >/dev/null 2>&1; then
    echo "Installing / using Ruby $RUBY_VERSION via RVM..."
    rvm install $RUBY_VERSION || true
    rvm use $RUBY_VERSION --default
elif command -v rbenv >/dev/null 2>&1; then
    echo "Installing / using Ruby $RUBY_VERSION via rbenv..."
    rbenv install -s $RUBY_VERSION
    rbenv global $RUBY_VERSION
    rbenv rehash
else
    echo "Warning: No RVM or rbenv found. Make sure Ruby $RUBY_VERSION is installed."
fi

ruby -v

# -----------------------------
# 3. Restore original Gemfile/Gemfile.lock if using Git
# -----------------------------
if command -v git >/dev/null 2>&1; then
    echo "Restoring Gemfile and Gemfile.lock from Git..."
    git checkout Gemfile || true
    git checkout Gemfile.lock || true
fi

# -----------------------------
# 4. Install Bundler
# -----------------------------
echo "Installing Bundler $BUNDLER_VERSION..."
gem install bundler -v $BUNDLER_VERSION
bundle _${BUNDLER_VERSION}_ install

# -----------------------------
# 5. Clean up old gems
# -----------------------------
echo "Cleaning up old gems..."
gem cleanup || true
rm -rf vendor/bundle || true
bundle _${BUNDLER_VERSION}_ install

# -----------------------------
# 6. Serve Jekyll
# -----------------------------
echo "Serving Jekyll site..."
bundle _${BUNDLER_VERSION}_ exec jekyll serve
