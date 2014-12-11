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

```
> gem install megahal
> megahal
```

Copyright
---------

Copyright (c) 2014 Jason Hutchens. See UNLICENSE for further details.
