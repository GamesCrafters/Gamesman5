G5
==

This is Gamesman5.

As of the writing of this document, this is the state of the project:

Framework
---------

This app is built on Sinatra, a lightweight web framework written in ruby, but
this shouldn't matter to the average gamescrafter writing games.

### To run gamesman5 locally

Make sure you have ruby installed and then do the following:
```bash
$ gem install bundler
$ bundle install
$ rackup
```
Once you've run it for the first time, all you will need to do is
```bash
$ rackup
```
If you pull and you start seeing errors when you try to start the server. Try running
```bash
$ bundle install
```
again. 

### To add a new game

For an example game file. Look at:
```
./assets/javascripts/games/ttt.coffee
```

This is a file written in [CoffeeScript](http://coffeescript.org/) a language that compiles into javascript.

To implement a new game, you will need to add a new file like ttt.coffee. Along with that, you will need to add
a file like
```
./assets/xml/games/ttt.xml
```
that tells the game system information about your game. You will notice the
```xml
<hidden />
```
tag in some of the xml files. Use this when your game is not ready for prime time.

Finally you will need to add a png file to `./public/images/`.

And among all this make sure you use the same asset name. For example Tic Tac Toe always uses the asset name `ttt` 
for the coffescript file, the xml file, and its png. 

Following this, you should be able to create a fantastic game!
