omdl
====

> A documented mechanical design library for [OpenSCAD].

[![LGPL licensed](https://img.shields.io/badge/license-LGPL-blue.svg?style=flat)](https://raw.githubusercontent.com/royasutton/omdl/master/gnu-lgpl-v2.1.txt)


Setup
-----

To use [omdl], it must be installed to the OpenSCAD [library location].
A setup script is available to simplify the setup and install process.
This script can optionally install [openscad-amu], the the design-flow
automation development framework used to test the library and build its
documentation.

The setup script is the recommended install method. However, on-line
snapshots for manual installation are available at [omdl-snapshot].
There you can review the latest release documentation prior to
installing locally.


Installing
----------

To install the latest tagged release of [omdl], use the following
steps:

```bash
mkdir tmp && cd tmp
```

```bash
wget https://git.io/setup-omdl.bash && chmod +x setup-omdl.bash
```

```bash
./setup-omdl.bash --branch-list tags1 --no-excludes --yes --install
```

The option `--yes` can be omitted if you prefer to confirm the
installation of the required packages. If you don't like shortened
URLs, here is the full URL to [setup-omdl.bash] at the source
repository. Once setup completes, the *cache* directory can be removed.

View the installed library documentation with:

```bash
google-chrome ${HOME}/.local/share/OpenSCAD/docs/html/index.html
```

### Options

To install a specific library version, use:

```bash
./setup-omdl.bash --branch v0.6.1 --no-excludes --yes --install
```

To install a specific library version along with the [openscad-amu]
version used to build the library, use:

```bash
./setup-omdl.bash --branch v0.9.7 --no-excludes --yes --local-toolchain --install
```

For a complete list of setup options, type;

```bash
./setup-omdl.bash --help
```


Contributing
------------

[omdl] uses [git] for development tracking, and is hosted on [GitHub]
following the usual practice of [forking] and submitting [pull requests]
to the source [repository].

As it is released under the [GNU Lesser General Public License], any
file you change should bear your copyright notice alongside the
original authors' copyright notices typically located at the top of
each file.

Ideas, requests, comments, contributions, and constructive criticism
are welcome.


Bug reporting
-------------

Please feel free to raise any problems, concerns, or [issues].


[GNU Lesser General Public License]: https://www.gnu.org/licenses/lgpl.html

[setup-omdl.bash]: https://raw.githubusercontent.com/royasutton/omdl/master/share/scripts/setup-omdl.bash

[omdl]: https://royasutton.github.io/omdl
[repository]: https://github.com/royasutton/omdl
[issues]: https://github.com/royasutton/omdl/issues

[omdl-snapshot]: https://github.com/royasutton/omdl-snapshot

[openscad-amu]: https://royasutton.github.io/openscad-amu
[installing openscad-amu]: https://github.com/royasutton/openscad-amu#installing

[Doxygen]: http://www.stack.nl/~dimitri/doxygen/index.html

[OpenSCAD]: http://www.openscad.org
[library location]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries

[git]: http://git-scm.com
[GitHub]: http://github.com
[forking]: http://help.github.com/forking
[pull requests]: https://help.github.com/articles/about-pull-requests
