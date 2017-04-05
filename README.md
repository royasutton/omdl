omdl
====

> An open mechanical design library for [OpenSCAD].

[![LGPL licensed](https://img.shields.io/badge/license-LGPL-blue.svg?style=flat)](https://raw.githubusercontent.com/royasutton/omdl/master/lgpl-2.1.txt)

View live docs on [GitHib Pages](https://royasutton.github.io/omdl).


Setup
-----

To use [omdl] the library files must be copied to an OpenSCAD
[library location]. This can be done manually, as described in the
OpenSCAD documentation, or can be automated using [openscad-amu].

The ladder has several advantages and is recommended. When using
[openscad-amu], the library documentation is installed together with
the library source code. This documentation is also added to a local
[browsable index], which facilitates reference use. Moreover, with
openscad-amu installed, one can develop documentation for other
OpenSCAD design scripts.

### Recommended install method ###

#### Prerequisites ####

First install [openscad-amu]. A build script exists for *Linux* and
*Cygwin* (pull requests for *macOS* are welcome). If *wget* is not
available, here is a downloadable link to the [bootstrap] script

If the last step below reports the tool build version, then the install
likely completed successfully and the temporary directory may be
removed when desired. Dependent on your operating system, file system,
and/or user credentials, the install may require or may not elevated
privileges as indicated by *sudo*:

    $ mkdir tmp && cd tmp

    $ wget https://raw.githubusercontent.com/royasutton/openscad-amu/master/snapshots/bootstrap.{bash,conf} .
    $ chmod +x bootstrap.bash

    $ sudo ./bootstrap.bash --yes --install

    $ openscad-seam -v -V

More information can be found in the GitHib [amu repository], where the
source is maintained, and at [amu on Thingiverse].

#### omdl ####

Now [omdl] can be compiled, verified, and installed. First download the
source from the GitHub [repository], select the branch version, and
start the install as follows:

    $ git clone https://github.com/royasutton/omdl.git
    $ cd omdl
    $ git checkout v0.6

    $ make all
    $ make install

By default, the release shape manifests, the database tests, and
database statistics are not built, as controlled by the design flow
variable *scopes_exclude*. To build without exclude them, use the
following:

    $ make list-scopes_exclude

    $ make scopes_exclude="" all
    $ make install

Now the library should have been installed to the OpenSCAD *built-in*
library location along with the documentation that can be views with a
web browser. Multiple versions can be installed simultaneously.

Have a look in:
* **Linux:** $HOME/.local/share/OpenSCAD/libraries
* **Windows:** My Documents\\OpenSCAD\\libraries

Now you may include the desired library primitives in your project as
follows, replacing the version number as needed:

```
include <omdl-v0.6/shapes/shapes2de.scad>;
include <omdl-v0.6/shapes/shapes3d.scad>;
...
```

##### Snapshots #####

Library source release [snapshots] are periodically made available
in the repository and at [omdl on Thingiverse].


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

[snapshots]: https://github.com/royasutton/omdl/tree/master/snapshots
[browsable index]: https://royasutton.github.io/omdl/api/html

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
