HOWTO
======

*   Install XeTeX, Pandoc and other stuff.
*   `./waf configure`
*   while `./waf` is not succeeding

    * install missing stuff

*   while not happy with your text

    * Edit `.pd` files
    * _(sometimes)_ Edit `.latex` files
    * _(sometimes)_ Update `sources` in `wscript`
    * `./waf`



Nice links
===========

* [The Waf Book](https://waf.io/book/)
* Always feel free to refer to the [real-life example](https://github.com/kirelagin/ninja-thesis/tree/master)



Structure
==========

* Everything starts with `template.latex` which is a Pandoc template.
  Edit the first three lines of this file.
* `preamble.latex` has boring technical TeX stuff.
* `bib.bib` is the bibliography.
  Edit it with [KBibTeX](http://home.gna.org/kbibtex/) or something like that.
* `licenses.latex` is a list of licenses for artwork an source code used
  throughout the text. `Licenses.pd` is the last section that gives all the
  necessary attribution etc.
* `pseudo.latex` is the definition of a simple pseudocode programming language.
  You’ll probably want to extend it and/or define more languages (don’t forget
  to `\input` them in `preamble.latex`).
* `wscript` describes how to build everything and the `sources` variable
  is actually the only interesting thing there. See also:
  [Lifehack](https://github.com/kirelagin/ninja-thesis/blob/master/wscript#L24)
