#!/bin/bash

# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Pre-cache Flutter
flutter precache --web

# Run flutter doctor
flutter doctor

# Build the Flutter web app
flutter build web
