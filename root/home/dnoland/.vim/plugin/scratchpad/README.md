ScratchPad
==========

ScratchPad is a rather trivial vim plugin created for a single purpose: *to let me more easily write scripts in vim*.

This is accomplished mostly via the function ScratchPadOpen("suffix"), which opens two small splits side by side at the bottom of the screen.  The input buffer on the left is named /tmp/__scratch__.suffix and the buffer on the right is a scratch buffer.  <leader><cr> from the input buffer will execute the script (assuming it has a proper shebang line) and pipe its output to the right buffer.

I wrote this mostly to force myself to learn a little vimscript, but also because I wanted this functionality.  I am sure there is a better way to implement these features, and if you have one I would be interested to hear about it.  Feel free to laugh at my vim scripting skills, but feel especially free to send me a pull request if you fix bugs, improve code, write real documentation... basically if you feel like being useful, I am all for that.

Install
-------

If you use Vundle or Pathogen or some such you know what to do.  If you don't, learn.  You are suffering needlessly.
