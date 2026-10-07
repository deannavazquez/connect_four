# Connect Four

A two-player Connect Four game that runs in the terminal, written in Ruby and tested with RSpec. Built as part of The Odin Project's Ruby course.

## How to play

- Players take turns dropping a piece (🔴 or 🟡) into one of 7 columns.
- Enter a column number from 0 to 6 when prompted.
- The first player to connect four pieces in a row, column, or diagonal wins.
- If the board fills up with no winner, the game is a draw.

## Run it
ruby lib/game.rb

## Run the tests
bundle install
rspec


## What's tested

- Board creation (6 rows x 7 columns)
- Dropping a piece to the lowest empty row in a column
- Turn switching between players
- Move validation (full columns and out-of-range columns)
- Win detection: horizontal, vertical, and both diagonals
- Draw detection
- The turn loop, including retrying after invalid input
- The full game loop, ending in a win

## What I learned

- Writing tests first, then just enough code to pass
- Checking that a test can fail by temporarily breaking the code it protects
- Faking user input and capturing output in RSpec
- Keeping each method to one job

## Built with

Ruby, RSpec
