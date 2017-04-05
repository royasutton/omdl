omdl
====

> An open mechanical design library for [OpenSCAD].

[![LGPL licensed](https://img.shields.io/badge/license-LGPL-blue.svg?style=flat)](https://raw.githubusercontent.com/royasutton/omdl/master/lgpl-2.1.txt)

View live docs on [GitHib Pages](https://royasutton.github.io/omdl).


Using omdl
----------

To use [omdl] the library files must be copied to an OpenSCAD
[library location]. This can be done manually, as described in the
OpenSCAD documentation, or can be automated using [openscad-amu].

The ladder has several advantages and is recommended. When using
[openscad-amu], the library documentation is installed together with
the library source code. This documentation is also added to a local
[browsable index], which facilitates reference use. Moreover, with
openscad-amu installed, one can develop documentation for other
OpenSCAD design scripts.

Library releases are periodically made available in the [repository]
under [snapshots].

#### Recommended install method ####

First install [openscad-amu]. More information can be found at
[amu on Thingiverse] and in the GitHib [amu repository] where the
source is maintained.

A build script exists for *Linux* and *Cygwin* (pull requests for
*macOS* are welcome). If *wget* is not available, here is a
downloadable link to the [bootstrap] script.

    $ mkdir tmp && cd tmp

    $ wget https://raw.githubusercontent.com/royasutton/openscad-amu/master/snapshots/bootstrap.{bash,conf} .
    $ chmod +x bootstrap.bash

    $ ./bootstrap.bash --yes --install

    $ openscad-seam -v -V

If the last step reports the tool build version, then the install most
likely completed successfully and the temporary directory created in
the first step may be removed when desired.

Now the documentation for [omdl] can be compiled and installed with a
single command. First clone the source repository and install as
follows:

    $ git clone https://github.com/royasutton/omdl.git
    $ cd omdl

    $ make install

The library and documentation should now have been installed to the
OpenSCAD *built-in* library location along with the reference
manual that can be views with a web browser.

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

[git]: http://git-scm.com
[GitHub]: http://github.com
[forking]: http://help.github.com/forking
[pull requests]: https://help.github.com/articles/about-pull-requests
