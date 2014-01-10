# Domitem status page
## AKA - the single page product finder

There's a lot of mac mini specific stuff in both domsearch.pl and the
upstart example script. I included the upstart example script as a
reference only - it will need to be modified for your environment.

The fact that I'm using it to show the mac mini's status on
[isthereanewmacminiyet](http://isthereanewmacminiyet.dudid.com) is
obviously quite silly, but this code can easily be modified to do more
advanced searching and provide a RESTful json web service as to the
status of various states of other pages.

The entire app is one perl file and has only one dependency -
[mojolicious](http://mojolicio.us).
