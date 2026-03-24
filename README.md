omdl
====

> An open-source parametric framework for mechanical design in [OpenSCAD].

[![LGPL licensed](https://img.shields.io/badge/license-LGPL-blue.svg?style=flat)](https://raw.githubusercontent.com/royasutton/omdl/master/gnu-lgpl-v2.1.txt)


Setup
-----

To use [omdl], it must be installed in the OpenSCAD [library location].
A setup script is provided to simplify the installation and
configuration process. This script can optionally install
[openscad-amu], the design-flow automation framework used to test the
library and generate its documentation.

The setup script is the recommended installation method. Alternatively,
online snapshots are available for manual installation at
[omdl-snapshot]. These snapshots also allow you to review the latest
release documentation before installing the library locally.

Installing
----------

To install the latest tagged release of [omdl], use the following
steps:

```bash
mkdir tmp && cd tmp
```

```bash
wget https://raw.githubusercontent.com/royasutton/omdl/master/share/scripts/setup-omdl.bash
```

```bash
chmod +x setup-omdl.bash
```

```bash
./setup-omdl.bash --branch-list tags1 --no-excludes --yes --install
```

The `--yes` option may be omitted if you prefer to manually confirm the
installation of required packages. If shortened URLs are not preferred,
the full URL to setup-omdl.bash is available in the source repository
at [setup-omdl.bash]. After setup completes, the temporary cache
directory may be safely removed.

To view the installed library documentation, run:

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

[omdl] uses [git] for source control and development tracking, and is
hosted on [GitHub]. Contributions follow the standard open-source
workflow of creating a [fork] and submitting changes through [pull
requests] to the main [repository].

Because the project is released under the [GNU Lesser General Public
License (LGPL)], any modified file should retain the original copyright
notices and include your own copyright statement alongside those of the
original authors. These notices are typically located at the beginning
of each source file.

Ideas, feature requests, feedback, contributions, and constructive
criticism are always welcome and encouraged.

Bug reporting
-------------

Users and contributors are encouraged to report problems, concerns, or
suggestions by submitting an [issue].


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
