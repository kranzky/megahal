MegaHAL
=======

MegaHAL is a learning chatterbot.

TODO
----

* Generators
  + Memory
  + Utterance
  + Punctuation
  + Capitalisation
* Memory generator
  + Train on question/answer utterance pairs
  + Supply current memory and most recent observation
  + Correlate model
  + Return new memory
* Utterance generator
  + Train on utterance observations (no training for repair model)
  + Supply memory
  + Markov family with pathfinding
  + Repair model for removing invalid generations (same as capitalisation model)
  + Return a list of generations sorted by average information wrt keywords
* Punctuation generator
  + Train on utterance / punctuation sequences (no training for repair model)
  + Supply utterance
  + Insert model for all possible generations
  + Repair model for removing invalid generations (same as capitalisation model)
  + Long-distance model for generation scoring
  + Return generation with minimal entropy
* Capitalisation generator
  + Train on words / utterance / punctuation sequences
  + Repair model for capitalisation from punctuation
  + Repair model for capitalisation from words
  + Return most likely sequence

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
