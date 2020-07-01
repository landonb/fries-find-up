@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Home Fries Shell Scripts -- ``FindUp``
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

###################################
Bash "Invursive" Up-Dir File Finder
###################################

"Invursive", as in anti-recursive.

Drills up, not down.

=====
Usage
=====

In the simplest use case, searches up a directory tree looking
for an exact matching file or directory name. E.g.,

::

  $ tmpdir=$(mktemp -d)
  $ cd ${tmpdir}
  $ git init .
  $ mkdir test
  $ cd test
  $ fries-findup .git
  /tmp/tmp.XXXXXXXXXX/.git

You can also specify the directory to search as the first argument instead. E.g.,

::

  $ tmpdir=$(mktemp -d)
  $ cd ${tmpdir}
  $ git init .
  $ cd /
  $ fries-findup ${tmpdir} .git
  /tmp/tmp.XXXXXXXXXX/.git

For complete control, you can specify arguments to the ``find`` command and have
it run on every ancestor directory. E.g.,

::

  $ tmpdir=$(mktemp -d)
  $ cd ${tmpdir}
  $ git init .
  $ cd /
  $ fries-findup ${tmpdir} -name "*git" -o -name "tmp.*"
  /tmp/tmp.XXXXXXXXXX/.git
  /tmp/tmp.XXXXXXXXXX

============
Installation
============

So many options!

Choose wisely:

- Install systemwide (requires root).

- Install locally (relative to user).

- Install for development (symlinks).

Note: Be sure to ``source`` the script after installing it!

Read along for specific instructions.

Install Systemwide
------------------

Run any of these commands as the superuser to install systemwide to ``/usr/local/bin``.

- Install systemwide with a simple ``curl`` command:

  ::

    $ curl -Lo- "https://raw.githubusercontent.com/landonb/fries-findup/release/install.sh" | bash

  Which, if you trust me, you could run as root::

    sudo /bin/bash -c 'curl -Lo- "https://raw.githubusercontent.com/landonb/fries-findup/release/install.sh" | bash'

- Install systemwide using
  `bpkg <https://github.com/bpkg/bpkg>`__,
  "Bash package manager":

  ::

    $ bpkg install landonb/fries-findup

- Install systemwide using
  `basher <https://github.com/basherpm/basher>`__,
  "a package manager for shell scripts":

  ::

    $ basher install landonb/fries-findup

- Install systemwide using
  `clib <https://github.com/clibs/clib>`__,
  "package manager for C projects"
  (which also happens to fetch GitHub repos and run Makefiles):

  ::

    $ clib install landonb/fries-findup

After installing, source the installed file
(see `Update $PATH`_ for doing this automatically)::

  source /usr/local/bin/fries-findup

Install Locally
---------------

You can install the source locally, either for usage, or for development.

Install to Use
~~~~~~~~~~~~~~

- Download the source and install anywhere:

  ::

    $ tmpdir=$(mktemp -du)
    $ git clone https://github.com/landonb/fries-findup.git ${tmpdir} --depth 1
    $ cd ${tmpdir}
    $ PREFIX=anywhere/you/like make install
    $ cd ..
    $ /bin/rm -rf $(basename ${tmpdir})

Install to Develop
~~~~~~~~~~~~~~~~~~

- Download the source for create symlinks for development:

  ::

    $ git clone https://github.com/landonb/fries-findup.git path/to/fries-findup --depth 1
    $ cd path/to/fries-findup
    $ PREFIX=anywhere/you/like make link

  Then you can edit files and re-source the code all you want.

Source It
~~~~~~~~~

After installing, source the installed file (see below for doing this automatically)::

  source anywhere/you/like/bin/fries-findup

Update ``$PATH``
----------------

If you've come this far, you naturally know how to load shell scripts!

You can easily source the script for a one-off test::

  $ source anywhere/you/like/bin/fries-findup
  $ fries-findup

But you probably want to install to a directory on ``PATH``, or to update
``PATH``, to make the most of this project.

- Ensure that ``PATH`` includes the script's parent directory so that other
  scripts can find it as needed (i.e., when used as a dependency).
  For example, a script that uses this library might look like::

    #!/bin/bash
    source 'fries-findup'
    fries-findup somefile

- You probably have your own *dotfile* conventions for extending ``PATH``
  and for sourcing shell scripts.

  If not, you might want to consider a helper function, such as
  ``path_suffix`` from `sh-pather
  <https://github.com/landonb/sh-pather/blob/release/bin/path_suffix#L8>`__,
  to add to ``PATH`` without creating duplicate entries.

  Or, if you are lazy and just wanna wing it, you can run this command
  to update ``PATH`` from your Bash startup script::

    $ echo 'export PATH="${PATH}:anywhere/you/like/bin"' >> ~/.bashrc

  And you can run this command to load the function into your shell sessions::

    $ echo 'source "anywhere/you/like/bin/fries-findup"' >> ~/.bashrc

==============
Uninstallation
==============

You can uninstall or unlink similarly to installing or linking:

::

  $ cd path/to/landonb/fries-findup

  # And then:

  $ make uninstall

  # Or:

  $ make unlink

Note: You cannot run uninstall or unlink without fetching the source first!
(Although you could just manually remove files yourself, e.g., from
``/usr/local/bin`` and from ``/usr/local/man``, as appropriate.)

===========
Development
===========

Fork this repo, and follow the instructions above to clone the source and
install symlinks for development to your cloned remote. Then just submit
Pull Requests like you normally would.

===========
Online Help
===========

Refer to the man page for complete usage information.

After installing, run::

  $ man fries-findup

