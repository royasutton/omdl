omdl
====

> A documented mechanical design library for [OpenSCAD].

[![LGPL licensed](https://img.shields.io/badge/license-LGPL-blue.svg?style=flat)](https://raw.githubusercontent.com/royasutton/omdl/master/gnu-lgpl-v2.1.txt)

View live docs on [GitHub Pages](https://royasutton.github.io/omdl).


Setup
-----

In order to use [omdl], it should be be installed to the OpenSCAD
[library location]. It can be copied manually, as described in the
OpenSCAD documentation, or can be installed via [openscad-amu] (the
framework used to develop omdl). If latter is used, the library will be
tested and the documentation will be generated.

A setup script is available to download, build, and install the
dependencies.


Evaluation
----------

To setup the library to a temporary directory using the setup script,
open the command shell and type:

```bash
mkdir tmp && cd tmp
```

```bash
wget https://git.io/setup-omdl.bash
```

```bash
chmod +x setup-omdl.bash
```

```bash
./setup-omdl.bash --cache --branch-list tags1 --yes --install
```

The option `--yes` can be omitted if you prefer to confirm the
installation of the required packages (see: `setup-omdl.bash --help`
for more details). If you don't like shortened URLs, here is the full
URL to [setup-omdl.bash] at the source repository.

Once setup successfully completes, the library documentation can be
viewed from the temporary 'cache' directory:

```bash
firefox cache/local/share/OpenSCAD/docs/html/index.html
```

To setup the development branch, use:

```bash
./setup-omdl.bash --cache --branch develop --yes --install
```


Installing
----------

To install the latest tagged release to the OpenSCAD user library path
on your system, use these options:

```bash
./setup-omdl.bash --branch-list tags1 --no-excludes --yes --install
```

To install a specific library version, for example v0.6.1, use:

```bash
./setup-omdl.bash --branch v0.6.1 --no-excludes --yes --install
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

[openscad-amu]: https://royasutton.github.io/openscad-amu
[installing openscad-amu]: https://github.com/royasutton/openscad-amu#installing

[Doxygen]: http://www.stack.nl/~dimitri/doxygen/index.html

[OpenSCAD]: http://www.openscad.org
[library location]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries

[git]: http://git-scm.com
[GitHub]: http://github.com
[forking]: http://help.github.com/forking
[pull requests]: https://help.github.com/articles/about-pull-requests
