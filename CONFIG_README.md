# MovieFinder Configuration

## Setup

1. Copy the example configuration file:
   ```bash
   cp Config.xcconfig.example Config.xcconfig
   cp MovieFinder/Config.xcconfig.example MovieFinder/Config.xcconfig
   ```

2. Edit `Config.xcconfig` and `MovieFinder/Config.xcconfig` and replace `YOUR_TMDB_API_KEY_HERE` with your actual TMDB API key.

3. Get your API key from: https://www.themoviedb.org/settings/api

## Important

- **Never commit** `Config.xcconfig` files to version control as they contain sensitive API keys
- The `*.xcconfig.example` files are safe to commit as templates
- Make sure your actual `Config.xcconfig` files are listed in `.gitignore`
