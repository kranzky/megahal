MegaHAL
=======

MegaHAL is a learning chatterbot.

Design
------

First, we segment the sentence into three arrays of IDs (puncs, words and
norms). This is done partly for efficiency and partly to force us to abandon all
hope of meaning. We're just dealing with numbers. The inverse operation is
repairing the array of generated norms to yield a pleasing, correctly punctuated
sentence in a human language.

Given a sequence of norms, contexts of IDs (perhaps all triples of IDs
regardless of separation, omitting duplicates) exite percepts, which are added
to the short-term memory, with existing entries attenuated so the strongest
seven survive.

Given the short-term memory, a small collection of seeds is generated.  These
seeds are then used to build a sequence of norms such that the sequence
maximises the information of the seed collection. And this is repaired as above.

A question-answer pair that is confirmed to have relevance is used to train the
percept model. Percepts are created to represent triples from the question, and
are trained with IDs from the answer norm. Percepts are merged when they attain
a certain level of similarity with respect to their distribution.

The generation uses a markov model and a long-distance model. The latter allows
us to constrain the markovian generation based on the seeds that we're trying to
generate. This is a type of pathfinding.

To repair a sequence of norms we insert puncs using the insert model. We then
use a similar model to postulate words, one for adjacent puncs and one for
adjacent norms. We then choose the maximal sequence of words.

To many, perhaps all of the predictors but at least the percepts ones, we add the ability to forget:

* Rarely used entries in the distribution are removed
* Similar contexts are merged
* Low entropy contexts are removed

Contributing to megahal
-----------------------

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
---------

Copyright (c) 2012 Jason Hutchens. See LICENSE.txt for further details.
