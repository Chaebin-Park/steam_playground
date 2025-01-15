#!/bin/bash

# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable
# shellcheck disable=SC2006
# shellcheck disable=SC2155
export PATH="$PATH:`pwd`/flutter/bin"

# Pre-cache Flutter
flutter precache --web

# Run flutter doctor
flutter doctor

# Build the Flutter web app
flutter build web
