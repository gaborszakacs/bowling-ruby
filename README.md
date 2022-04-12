## Bowling

```
game = BowlingGame.new

game.roll 1
game.roll 2

game.roll 1
game.roll 3

game.roll 4
game.roll 5

game.score # should be 16

# spare:
1, 2 # 3
3, 7 # 10 + spare bonus 4
4, 2 # 6

# score should be 23

```

## Setup project

```
bundle
```

## Run tests

```
bundle exec rspec
```
