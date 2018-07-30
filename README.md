omdl
====

> An open mechanical design library for [OpenSCAD].

[![LGPL licensed](https://img.shields.io/badge/license-LGPL-blue.svg?style=flat)](https://raw.githubusercontent.com/royasutton/omdl/master/lgpl-2.1.txt)

View live docs on [GitHib Pages](https://royasutton.github.io/omdl).


Setup
-----

In order to use [omdl], it must be first be installed to an OpenSCAD
[library location] on your system. It can be copied manually, as
described in the OpenSCAD documentation, or can be installed via
[openscad-amu], the framework used to develop [omdl]. If [openscad-amu]
is used, the library documentation will be generated and added to an
index of [installed libraries] for convenient design reference.


Evaluation
----------

A setup script is available to build the development environment and
install the library to a temporary directory:

```bash
mkdir tmp && cd tmp
wget https://git.io/setup-omdl.bash
chmod +x setup-omdl.bash

./setup-omdl.bash --cache --branch-list tags1 --yes --install
```

The option `--yes` can be omitted if you prefer to confirm the
installation of each required package (see: `setup-omdl.bash --help`).
If you don't like shortened URLs, here is the full URL to
[setup-omdl.bash].

If all goes well, the library (and development framework) will have
been installed into a temporary directory named `cache`. Subsequently,
the omdl library documentation can be viewed by typing:

```bash
firefox cache/local/share/OpenSCAD/docs/html/index.html
```


Installing
----------

To install the latest tagged release of [omdl] to the OpenSCAD user
library path on your system, use these options:

```bash
./setup-omdl.bash --branch-list tags1 --no-excludes --yes --install
```

To install a specific [omdl] library version, for example v0.6.1, use:

```bash
./setup-omdl.bash --branch v0.6.1 --no-excludes --yes --install
```

Use library components in your OpenSCAD designs as expected, replacing
the version number as appropriate:

```bash
include <omdl-v0.6.1/omdl-base.scad>;
...
```

Manual Compilation
------------------

To make changes to [omdl] or rebuild it manually, make sure the
variables `AMU_LIB_PATH` and `AMU_TOOL_PREFIX` (trailing directory
slash required for the latter) are set to the *absolute paths* for your
installation of [openscad-amu] in the project `Makefile`. See
[installing openscad-amu] for more information.

To update project Makefile and build HTML documentation:

```bash
cd cache/omdl
vi Makefile                   # (set AMU_* variables absolute paths)

make help
make info
make generate_latex="" all    # skips latex generation
...
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


Contact and Support
-------------------

In case you have any questions or would like to make feature requests,
you can contact the maintainer of the project or file an [issue].


[GNU Lesser General Public License]: https://www.gnu.org/licenses/lgpl.html

[setup-omdl.bash]: https://raw.githubusercontent.com/royasutton/omdl/master/share/scripts/setup-omdl.bash

[omdl]: https://royasutton.github.io/omdl
[repository]: https://github.com/royasutton/omdl
[issue]: https://github.com/royasutton/omdl/issues

[installed libraries]: https://royasutton.github.io/omdl/api/html

[openscad-amu]: https://royasutton.github.io/openscad-amu
[installing openscad-amu]: https://github.com/royasutton/openscad-amu#installing

[Doxygen]: http://www.stack.nl/~dimitri/doxygen/index.html

[OpenSCAD]: http://www.openscad.org
[library location]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries

[git]: http://git-scm.com
[GitHub]: http://github.com
[forking]: http://help.github.com/forking
[pull requests]: https://help.github.com/articles/about-pull-requests
