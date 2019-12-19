OpenType for Global Scripts
===========================

In the last chapter, we looked at OpenType features from the perspective of technology: what cool things can we make the font do? In this chapter, however, we're going to look from the perspective of language: how do we make the font support the kind of language features we need? We'll be putting together the substitution and positioning lookups from OpenType Layout that we learnt about in the previous chapter, and using them to create fonts which behave correctly and beautifully for the needs of different scripts and language systems.

### Script and language handling

OpenType fonts can support special handling for multiple different scripts and for multiple different languages within the same font. You can, for example, substitute generic glyph forms for localised forms which are more appropriate in certain linguistic contexts: for example, the Serbian form of the letter be (б) is expected to look different from the Russian form. Both forms can be stored in the same font, and the choice of appropriate glyph made on the basis of the language of the text.

How does this work? The shaper is told, by the layout application, what language and script are being used by the input run of text. (It may also try guessing the script based on the Unicode characters in use.) The script and language are described using four-character codes called "tags"; for example, the script tag for Malayalam is `mlm2`. You can find the list of [script tags](https://docs.microsoft.com/en-gb/typography/opentype/spec/scripttags) and [language tags](https://docs.microsoft.com/en-gb/typography/opentype/spec/languagetags) in the OpenType specification.

To find the appropriate set of features, we take the language and script of the input, and see if there is a set of features defined for that language/script combination. If not, we look at the features defined for the input script and the default language for that script. If that's not defined, then we look at the features defined for the `dflt` script. For example, if you have text that we know to be in Urdu (language tag `URD`) using the Arabic script (script tag `arab`), the shaper will first check if Arabic is included in the script table. If it is, the shaper will then look to see if there are any rules defined for Urdu inside the Arabic script rules; if there are, it will use them. If not, it will use the "default" rules for the Arabic script. If the script table doesn't have any rules for Arabic at all, it'll instead pretend that the script is called `DFLT` and use the feature list defined for that script.

Inside the font, the GSUB and GPOS tables are arranged *first* by script, *then* by language, and finally by feature. But that's a confusing way for font designers to work, so AFDKO syntax allows you to do things the other way around: define your features and write script- and language-specific code inside them. To make this work, however, you have to define your "language systems" at the start of the feature file, like so:

    languagesystem DFLT dflt;
    languagesystem arab dflt;
    languagesystem arab ARA;
    languagesystem arab URD;
    languagesystem latn dflt;
    languagesystem latn TRK;

This font will have support for Arabic and Urdu, as well as Turkish and "default" (non-language-specific) handling of the Latin script.

XXX exclude_dflt goes here

## Features
### Problems with "i"

Turkish i
ccmp in Selawik

### Serbian be
### Polish Kreska
### Navajo Ogonek
### Arabic, Urdu and Sindhi

Local forms. Calligraphic forms.

## (Lots of Devanagari etc. needs to go here)

Reph forms.
See e.g.

https://github.com/itfoundry/hind/blob/master/family.fea

## Other tables
### Baselines
### Vertical typesetting
### Anchors
### Mark-to-mark / mark-to-base
### Entry / Exit
## USE

### Resources

http://theinsectsproject.eu

