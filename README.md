[![Gem Version](https://badge.fury.io/rb/megahal.svg)](http://badge.fury.io/rb/megahal)
[![Dependency Status](https://gemnasium.com/jasonhutchens/megahal.png)](https://gemnasium.com/jasonhutchens/megahal)
[![Build Status](https://semaphoreapp.com/api/v1/projects/6889bf33-e547-4200-a4fb-66b339a83d82/307128/shields_badge.svg)](https://semaphoreapp.com/jasonhutchens/megahal)
[![Code Climate](https://codeclimate.com/github/jasonhutchens/megahal.png)](https://codeclimate.com/github/jasonhutchens/megahal)

MegaHAL
=======

MegaHAL is a learning chatterbot.

You can run it as a command-line application, or embed it in your own
application and make calls to it via a simple
[API](http://rubydoc.info/github/jasonhutchens/megahal/master/frames).

It is build on top of [Sooth](https://github.com/jasonhutchens/sooth), a simple
stochastic predictive model.

This new version of MegaHAL was written quickly in homage of the original,
which existed as early as 1991. The first record I have of it is the following
USENET announcement from April 30, 1995.

Have a weird conversation with a computer
-----------------------------------------

Recently I added a feature to my home page allowing the user to "talk" to a
computer program of mine.  The program was not written very intelligently, so
most of the time its replies consisted of incoherent babble.

Version 2 came and went, and now version 3 - MegaHAL - is ready for release.
The new features of the program are:-

* A second-order markov model is used, and it is doubly-linked.  This
  means that the computers sentences tend to be more grammatical.
* Punctuation is supported, which segments the sentences realistically.
* The reply given by the computer is based upon one of the words in
  the input string.  The word selected is one that maximises the ratio
  (number of times since word was last used)/(number of times word has
  appeared).
* The computers reply is generated from this keyword, and may be up to
  100 words long.  The reply is generated in such a way that it is
  impossible to get stuck in infinite loops.
* The keyword used is highlighted in the reply.

Some example conversations are given below:-

```
USER: you are crazy
HAL:  WE *ARE* WEIRD.

USER: What is the meaning of life oh wise one?
HAL:  *LIFE* IS THE ROOM.

USER: this is not getting us very far
HAL:  YES I AM *GETTING* BORED OF GLOBAL DOMINATION.

USER: I have no idea.
HAL:  *NO* IT IS IN HEAVEN.
USER: Is it really?
HAL:  YES *IT* IS.

USER: My name is Jason.
HAL:  I THINK ALAN TURING WAS A GIRLIE, JUST LIKE *MY* DEAR MAMA
```

The last response was generated from a combination of a discussion
about Alan Turing, and Monty Python's Lumberjack Song.  Surely this
must be a sign of intelligence ;^)

Have fun!

Getting Started
---------------

Running the command-line version of MegaHAL is simple:

```
> gem install megahal
> megahal
+----------------------------------------------------------+
|                                                          |
|  #    #  ######   ####     ##    #    #    ##    #       |
|  ##  ##  #       #    #   #  #   #    #   #  #   #       |
|  # ## #  #####   #       #    #  ######  #    #  #       |
|  #    #  #       #  ###  ######  #    #  ######  #       |
|  #    #  #       #    #  #    #  #    #  #    #  #       |
|  #    #  ######   ####   #    #  #    #  #    #  ######  |
|                                                          |
|    Type "/help" for options and "/quit" to terminate.    |
+----------------------------------------------------------+

Greetings and salutations to thee and thine.
>
```

If you type `/help` at the prompt, you'll be presented with a menu:

```
1. cancel
2. reset
3. brain
4. train
5. load
6. save
7. characters
8. ignore
9. quit
```

Make a selection by typing the number or the name of the menu item:

1. `cancel`: go back without making a selection
1. `reset`: clear MegaHAL's brain, resetting to a blank slate
1. `brain`: choose from a number of existing personalities (see below)
1. `train`: give MegaHAL a plain text file to learn from
1. `load`: load a previously saved brain from a file
1. `save`: save the current MegaHAL brain to a file
1. `characters`: make MegaHAL use characters instead of words; this may be better for some languages (such as Chinese)
1. `ignore`: prevent MegaHAL from learning from user input; this is good if you want to chat without introducing changes to the brain

If you select the `brain` menu item above, you'll be presented with a list of
pre-existing MegaHAL brains to choose from:

1. `cancel`: go back without making a selection
2. `default`: the personality used for the 1998 Loebner competition
3. `aliens`: talk with Bishop from Aliens!
4. `bill`: talk with Bill Clinton (thanks to Matt Stokes)!
5. `caitsith`: talk with Cait Sith from FFVII (thanks to Sailor Solathei)
6. `ferris`: talk with Mr. Ferris Bueller himself! Bueller! Bueller!
7. `manson`: talk with MegaMANSON, the Marylin Manson personality (thanks to Jonathan Peck)
8. `pepys`: talk with Samuel Pepys, taken from the @samuelpepys Twitter feed
9. `pulp`: talk with Marsellus Wallace from Pulp Fiction!
10. `scream`: talk with Randy from Scream!
11. `sherlock`: talk with Sherlock Holmes, with quotes taken from all the books
12. `startrek`: talk with Data from Star Trek (thanks to mbaker)
13. `starwars`: talk with Threepio from the Star Wars Trilogy!

Example
-------

Here is an example conversation transcript:

```
```

Copyright
---------

Copyright (c) 2014 Jason Hutchens. See UNLICENSE for further details.
