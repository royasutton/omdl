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


### Recommended install method ###

#### Prerequisites ####

First [bootstrap] and verify the development environment, as follows:

    $ mkdir tmp && cd tmp
    $ wget https://raw.githubusercontent.com/royasutton/openscad-amu/master/snapshots/bootstrap.{bash,conf} .
    $ chmod +x bootstrap.bash

    $ sudo ./bootstrap.bash --branch-list tags1 --reconfigure --install
    $ openscad-seam -v -V

The last command should report the version of the [openscad-amu]
tool-chain installed. More information can be found in the GitHib
[amu repository], where the source is maintained, or at
[amu on Thingiverse].


#### omdl ####

Now you are ready to install [omdl].

The following will clone the source repository, checkout the latest
release, run library validation and build the documentation, and
install the library and documentation to an OS-dependent location.
Validation and build may take some time.

    $ git clone https://github.com/royasutton/omdl.git
    $ cd omdl
    $ git checkout `git describe --tags --abbrev=0`

    $ make scopes_exclude="" all
    $ make install

Other release versions can be checked-out and installed concurrently
with existing versions using these steps replacing the argument to
`git checkout` with the version of interest. To see a list of release
versions type `git tag`.

Thats it, your done. To browse the library or its documentation, type:

    $ make print-install_prefix_scad
    $ ls <install_prefix_scad>

    $ make print-install_prefix_html
    $ firefox <install_prefix_html>/index.html

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

[omdl]: https://royasutton.github.io/omdl
[repository]: https://github.com/royasutton/omdl
[issue]: https://github.com/royasutton/omdl/issues

[installed libraries]: https://royasutton.github.io/omdl/api/html

[openscad-amu]: https://royasutton.github.io/openscad-amu
[amu repository]: https://github.com/royasutton/openscad-amu
[bootstrap]: https://raw.githubusercontent.com/royasutton/openscad-amu/master/snapshots/bootstrap.bash

[Doxygen]: http://www.stack.nl/~dimitri/doxygen/index.html

[OpenSCAD]: http://www.openscad.org
[library location]: https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries

[Thingiverse]: http://www.thingiverse.com
[amu on Thingiverse]: http://www.thingiverse.com/thing:1858181
[omdl on Thingiverse]: http://www.thingiverse.com/thing:1934498

[git]: http://git-scm.com
[GitHub]: http://github.com
[forking]: http://help.github.com/forking
[pull requests]: https://help.github.com/articles/about-pull-requests
