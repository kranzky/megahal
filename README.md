[![Gem Version](https://badge.fury.io/rb/megahal.svg)](http://badge.fury.io/rb/megahal)
[![Codeship Status for jasonhutchens/megahal](https://codeship.com/projects/8f43e890-e5b4-0132-1716-266c7b4e6c8b/status?branch=master)](https://codeship.com/projects/82076)

MegaHAL
=======

MegaHAL is a learning chatterbot.

![Sherlock Holmes](https://www.kranzky.com/img/portfolio/megahal.png)

You can run it as a command-line application, or embed it in your own
application and make calls to it via a simple
[API](http://www.rubydoc.info/gems/megahal/). For example, see
the [megahal-server](http://github.com/jasonhutchens/megahal-server) repository,
which allows you to [chat with MegaHAL online](http://megahal.kranzky.com/).

It is built on top of [Sooth](https://github.com/jasonhutchens/sooth), a simple
stochastic predictive model.

This new version of MegaHAL was written in homage of the original, which I wrote
around twenty years ago. As these things go, the Ruby version is a fraction of
the size of the [original C version](https://github.com/pteichman/megahal/blob/master/Megahal/megahal.c).

The oldest record I have of MegaHAL is a USENET post from April 30, 1995,
which is reproduced at the bottom of this README.

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
7. ignore
8. quit
```

Make a selection by typing the number or the name of the menu item:

1. `cancel`: go back without making a selection
1. `reset`: clear MegaHAL's brain, restoring it to a blank slate
1. `brain`: choose from a number of existing personalities (see below)
1. `train`: give MegaHAL a plain text file to learn from
1. `load`: load a previously saved brain from a file
1. `save`: save the current MegaHAL brain to a file
1. `ignore`: prevent MegaHAL from learning from user input; this is good if you want to chat without introducing changes to the brain
1. `quit`: immediately exit MegaHAL, losing any unsaved changes

If you select the `brain` menu item above, you'll be presented with a list of
pre-existing MegaHAL brains to choose from:

1. `cancel`: go back without making a selection
2. `default`: the personality used for the 1998 Loebner competition
3. `aliens`: Bishop from Aliens!
4. `ferris`: Mr. Ferris Bueller himself! Bueller! Bueller!
5. `pepys`: Samuel Pepys, taken from the @samuelpepys Twitter feed
6. `pulp`: Marsellus Wallace from Pulp Fiction!
7. `sherlock`: Sherlock Holmes, with quotes taken from all the books
8. `startrek`: Data from Star Trek (thanks to mbaker)
9. `starwars`: Threepio from the Star Wars Trilogy!

Example
-------

Here is an example conversation transcript, taken directly from the `megahal.log` file (which is written each time you interact with MegaHAL):

```
(brain changed to sherlock holmes)
MH10: On the strange coincidences, the plannings, the cross-purposes, the wonderful chains of events, working through generations, and leading to the composition of a woman.
USER: Who are you?
MH10: You could never guess how I employed my morning, or what I ended by doing.
USER: Did you play a game?
MH10: Come, Watson, come! The game is afoot.
USER: How exciting!
MH10: Isn't it gorgeous! What do you think of it.
USER: I think it's great. What are we going to do?
MH10: I think, perhaps, it is simplicity itself.
USER: Tell me then.
MH10: Your statement is, I want you?
USER: Ummm... no.
MH10: Yes, certainly.
USER: I think you're confused.
MH10: I think that you have been too busy to think of it.
USER: Are you saying what I think you're saying?
MH10: You know how to look into it.
USER: So do you by the sound of it.
MH10: I have been of material assistance to me for fifty minutes.
USER: Is this non-stop double entendre?
MH10: More than that it is a great thing for me to be able to understand that I have ever listened.
USER: Let's go and do something. Or get a bite to eat.
MH10: That is interesting.
USER: Why?
MH10: Because there are fifty who can reason analytically.
USER: Name them.
MH10: My name is Sherlock Holmes.
USER: And who are the other forty-nine?
MH10: I want to ascertain.
USER: You mean that you don't know?
MH10: Light a cigar and let me see if I can do what you have told me I think that both inferences are permissible.
USER: Well, it's been interesting. I must leave.
MH10: No crime, but a very interesting statement.
USER: Goodbye.
MH10: You must get home instantly and act.
MegaHAL Stopped
```

USENET Announcement from 1995
-----------------------------

```
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

The last response was generated from a combination of a discussion
about Alan Turing, and Monty Python's Lumberjack Song.  Surely this
must be a sign of intelligence ;^)

Have fun!
```

Copyright
---------

Copyright (c) 2018 Jason Hutchens. See UNLICENSE for further details.
