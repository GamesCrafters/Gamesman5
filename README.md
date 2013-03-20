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

### To Contribute to the codebase

Make sure you clone the repository with the following URL:
```bash
$ git clone git@github.com:GamesCrafters/Gamesman5.git
```

Then, when you want to add to the project, make a branch. 

```bash
$ git branch <your-branch>
$ git checkout <your-branch>
```
Now, you will have some local changes to your branch. When you want to push to the 
github repository (which you should do frequently), run the following command:

```bash
$ git push origin <your-branch>
```

As you work, some changes may be made to the master branch. In order to incorporate these changes into
your branch, run the following commands.

```bash
$ git checkout <your-branch> # to make sure you are on your own branch
$ git fetch origin
$ git merge origin/master
```

This will then add several commits to your local copy, at which pount you should run:

```bash
$ git push origin <your-branch>
```
When you finally want to add your changes to the main repository, submit a pull request.
