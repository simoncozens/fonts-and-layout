How OpenType Works
==================

## What is a font?

## FontTools and ttx

To help us understand more about what a font actually is, we're going to use a set of Python programs called `fonttools`, originally written by Just van Rossum, but now maintained by Behdad Esfahbod and a cast of hundreds. If you don't have `fonttools` already installed, you can get hold of it by issuing the following commands at a command prompt:

XXX sidenote explaining terminals here

    easy_install pip
    pip install fonttools

If you have the Homebrew package manager installed, which is highly recommended for developing on Mac computers, you can get fonttools through Homebrew:

    brew install fonttools

XXX sidenote on Homebrew

The core of the `fonttools` package is a library, some code which helps Python programmers to write programs for manipulating font files. But `fonttools` includes a number of programs already written using the library, and one of these is called `ttx`. `ttx` is used to turn an OpenType or TrueType font into a textual representation, XML. The XML format is designed primarily to be read by computers rather than humans, but it allows us to peek inside the contents of an OpenType font which would otherwise be totally opaque to us.

## Exploring OpenType with `ttx`

To begin investigating how OpenType works, I started by creating a completely empty font in Glyphs, turned off exporting all glyphs apart from the letter "A" - which has no paths - and exported it as an OpenType file. Now let's prod at it with `ttx`.

First, let's list what tables we have present in the font:

    $ ttx -l TTXTest-Regular.otf
    Listing table info for "TTXTest-Regular.otf":
        tag     checksum   length   offset
        ----  ----------  -------  -------
        CFF   0x187D42BC      292     1088
        GSUB  0x00010000       10     1380
        OS/2  0x683D6751       96      280
        cmap  0x00140127       72      984
        head  0x091C432A       54      180
        hhea  0x05E10189       36      244
        hmtx  0x044C005D        8      236
        maxp  0x00025000        6      172
        name  0x6BFD9C8F      606      376
        post  0xFFB80032       32     1056

All apart from the first two tables in our file are required in every TrueType and OpenType font. Here is what these tables are for:

`OS/2`
: glyph metrics used historically by OS/2 and Windows platforms

`cmap`
: mapping between characters and glyphs

`head`
: basic font metadata

`hhea`
: basic information for horizontal typesetting

`hmtx`
: horizontal metrics (width and left sidebearing) of each character

`maxp`
: information used by for the font processor when loading the font

`name`
: a table of "names" - textual descriptions and information about the font

`post`
: information used when downloading fonts to PostScript printers

The first table, `CFF`, is required if the outlines of the font are represented as PostScript CFF; a font using TrueType representation will have a different set of tables instead (`cvt`, `fpgm`, `glyf`, `loca` and `prep`). The second table in our list, `GSUB`, is one of the more exciting ones; it's the glyph substitution font which, together with `GPOS` (glyph positioning), stores most of the OpenType smarts.

So those are the tables available to us. Now let us examine those tables by turning the whole font into an XML document:

    $ ttx TTXTest-Regular.otf
    Dumping "TTXTest-Regular.otf" to "TTXTest-Regular.ttx"...
    Dumping 'GlyphOrder' table...
    Dumping 'head' table...
    Dumping 'hhea' table...
    Dumping 'maxp' table...
    Dumping 'OS/2' table...
    Dumping 'name' table...
    Dumping 'cmap' table...
    Dumping 'post' table...
    Dumping 'CFF ' table...
    Dumping 'GSUB' table...
    Dumping 'hmtx' table...

This produces a `ttx` file, which is the XML representation of the font, containing the tables mentioned above. But first, notice we have a new table, which did not appear in our list - `GlyphOrder`. This is the mapping that TTX has used between the Glyph IDs in the font and some human readable names. Looking at the file we see the table as follows:

```
  <GlyphOrder>
    <!-- The 'id' attribute is only for humans; it is ignored when parsed. -->
    <GlyphID id="0" name=".notdef"/>
    <GlyphID id="1" name="A"/>
  </GlyphOrder>
```

Here we see our exported glyph `A`, and the special glyph `.notdef` which is used when the font is called upon to display a glyph that is not present. The Glyphs software provides us with a default `.notdef` which looks like this: ![notdef](opentype/notdef.png)


The `post` and `maxp` tables are essentially *aides memoire* for the computer; they are a compilation of values automatically computed from other parts of the font, so we will not examing them any more.