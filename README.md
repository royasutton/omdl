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
is used, the documentation is also generated and added to an index of
[installed libraries] for convenient design reference.


### Evaluation ###

A script is available to bootstrap the development environment and setup
the library in a temporary directory:

    $ mkdir tmp && cd tmp
    $ wget https://git.io/setup-omdl.bash
    $ chmod +x setup-omdl.bash

    $ ./setup-omdl.bash --cache --branch-list tags1 --yes --install

The option `--yes` can be omitted if you prefer to confirm the
installation of each required package (see: `setup-omdl.bash --help`).
If you don't like shortened URLs, here is the full URL to
[setup-omdl.bash].

If all goes well, the library will have been installed into a directory
named `cache`. The library documentation can be viewed by typing:

    $ firefox cache/local/share/OpenSCAD/docs/html/index.html


### Installing ###

To install the latest omdl to the OpenSCAD user library path on your
system, use these script options:

    $ ./setup-omdl.bash --branch-list tags1 --no-excludes --yes --install

To install a specific version of the library, for example v0.6.1:

    $ ./setup-omdl.bash --branch v0.6.1 --no-excludes --yes --install

To identify the location of the installed library documentation:

    $ cd cache/omdl
    $ make print-install_prefix_html

Use library components in your project as expected, replacing the
version number as needed:

```
include <omdl-v0.6.1/omdl-base.scad>;
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

[Doxygen]: http://www.stack.nl/~dimitri/doxygen/index.html

[OpenSCAD]: http://www.openscad.org
[library location]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries

[git]: http://git-scm.com
[GitHub]: http://github.com
[forking]: http://help.github.com/forking
[pull requests]: https://help.github.com/articles/about-pull-requests
