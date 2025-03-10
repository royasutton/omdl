omdl
====

> A documented mechanical design library for [OpenSCAD].

[![LGPL licensed](https://img.shields.io/badge/license-LGPL-blue.svg?style=flat)](https://raw.githubusercontent.com/royasutton/omdl/master/gnu-lgpl-v2.1.txt)


Setup
-----

To use [omdl], it should be installed to the OpenSCAD [library
location]. A setup script is available to simplify the setup process.
This script can also install [openscad-amu], the the design-flow
automation development framework used to test the library and build its
documentation.

The setup script is the recommended install method. However, on-line
documentation and snapshots for manual installation are available in
the [omdl-snapshot] repository.


Installing
----------

To install the latest release to the standard OpenSCAD user library
path, use the following steps:

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
installation of the required packages (see: `setup-omdl.bash --help`
for more details). If you don't like shortened URLs, here is the full
URL to [setup-omdl.bash] at the source repository.

Once setup completes, the *cache* directory can be removed and the
library documentation can be viewed:

```bash
google-chrome ${HOME}/.local/share/OpenSCAD/docs/html/index.html
```

To install a specific library version, ie v0.6.1, use:

```bash
./setup-omdl.bash --branch v0.6.1 --no-excludes --yes --install
```

To install the design-flow automation development framework version
used to build the library to your system, use:

```bash
./setup-omdl.bash --branch v0.6.1 --no-excludes --yes --local-toolchain --install
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
