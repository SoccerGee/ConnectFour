# README

Simple Connect Four Game.

This was built using Rails and Postgres with minimal JQuery for RESTful calls.

The Computer player does a basic scoring algorithm to decide where to place it's moves.

There are User accounts using devise.  Each User has a game and has many moves.  Each Game has many moves and two Users.  Each move belongs to a User and a Game.

The Game is given a BoardService which treats each possible space as an entity separate from a Move.  Space's are structs that have an x coordinate, y coordinate, user id, move id, threat score, and opportunity score.  The scores are used to help the cpu decide which play to make.

The BoardService also calculates win conditions for the Game, based on occupied spaces.

Struct's were used instead of generic hash because of speed of accessing the data out performs Hashes, and the attributes were of a fixed definition.

Good luck and have fun!
