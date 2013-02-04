duplicates-database
===================

are you like me and have tons of copies of files scattered all around your hard drives?

this is my attempt at identifying all those files and storing them in a neat database that be can used both as a cache and a querying mechanism to delete the largest or most duplicated files.

usage
=====

```
ruby dd.rb -d [directory]
```

the tool will scan the given directory and store the path, size and md5 hash for all the files scanned

todo
====

- add tests!
- add some standard queries (see the largest or most duplicated files) once the database is populated
- web interface (with sinatra)

how to contribute
=================

at this time the tool is in its very early stages, but any help is appreciated, especially with writing unit tests :)
