---
layout: chapter
title: OpenType for Global Scripts
---

In the last chapter, we looked at OpenType features from the perspective of technology: what cool things can we make the font do? In this chapter, however, we're going to look from the perspective of language: how do we make the font support the kind of language features we need? We'll be putting together the substitution and positioning lookups from OpenType Layout that we learnt about in the previous chapter, and using them to create fonts which behave correctly and beautifully for the needs of different scripts and language systems.

### Script and language handling

OpenType fonts can support special handling for multiple different scripts and for multiple different languages within the same font. You can, for example, substitute generic glyph forms for localised forms which are more appropriate in certain linguistic contexts: for example, the Serbian form of the letter be (б) is expected to look different from the Russian form. Both forms can be stored in the same font, and the choice of appropriate glyph made on the basis of the language of the text.

How does this work? The shaper is told, by the layout application, what language and script are being used by the input run of text. (It may also try guessing the script based on the Unicode characters in use.) The script and language are described using four-character codes called "tags"; for example, the script tag for Malayalam is `mlm2`. You can find the list of [script tags](https://docs.microsoft.com/en-gb/typography/opentype/spec/scripttags) and [language tags](https://docs.microsoft.com/en-gb/typography/opentype/spec/languagetags) in the OpenType specification.

To find the appropriate set of features, we take the language and script of the input, and see if there is a set of features defined for that language/script combination. If not, we look at the features defined for the input script and the default language for that script. If that's not defined, then we look at the features defined for the `dflt` script. For example, if you have text that we know to be in Urdu (language tag `URD`) using the Arabic script (script tag `arab`), the shaper will first check if Arabic is included in the script table. If it is, the shaper will then look to see if there are any rules defined for Urdu inside the Arabic script rules; if there are, it will use them. If not, it will use the "default" rules for the Arabic script. If the script table doesn't have any rules for Arabic at all, it'll instead pretend that the script is called `DFLT` and use the feature list defined for that script.

Inside the font, the GSUB and GPOS tables are arranged *first* by script, *then* by language, and finally by feature. But that's a confusing way for font designers to work, so AFDKO syntax allows you to do things the other way around: define your features and write script- and language-specific code inside them. To make this work, however, you have to define your "language systems" at the start of the feature file, like so:

    # languagesystem <script tag> <language tag>;
    languagesystem DFLT dflt;
    languagesystem arab dflt;
    languagesystem arab ARA;
    languagesystem arab URD;
    languagesystem latn dflt;
    languagesystem latn TRK;

This font will have support for Arabic and Urdu, as well as Turkish and "default" (non-language-specific) handling of the Latin script, non-language-specific handling of Arabic *script* (for instance, if the font is used for documents written in Persian; "Arabic" in this case includes Persian letters), and rules that apply generally.

Once we have declared what systems we're going to work with, we can specify that particular lookups apply to particular language systems. So for instance, the Urdu digits four, five and seven have a different form to the Arabic digits. If our font is to support both Arabic and Urdu, we should make sure to substitute the expected forms of the digits when the input text is in Urdu.

We'll do this using a `locl` (localisation) feature which only applies in the case of Urdu:

    feature locl {
        script arab;
        language URD;
        # All rules here apply to Urdu until the next script/language
        sub four-ar by four-ar.urd;
        sub five-ar by five-ar.urd;
        sub seven-ar by seven-ar.urd;
    } locl;

Any rules which appear *before* the first `script` keyword in a setting are considered "default rules" which apply to all scripts and languages. If you want to specify that they should *not* appear for a particular language environment, you need to use the declaration `exclude_dflt` like so:

    feature liga {
        script latn;
        sub f i by fi; # All Latin-based languages get the fi ligature.

        language TRK exclude_dflt; # Except Turkish. Turkish doesn't.
    } locl;

You may also see `include_dflt` in other people's feature files. The default rules are included by, uh, default, so this doesn't actually do anything, but making that explicit can be useful documentation to help you figure out what rules are being applied.

## Features in Practice

Up to this point, I have very confidently told you which features you need to use to achieve certain goals - for example, I said things like "We'll put a contextual rule in the `akhn` feature to make the Kssa conjunct." But when it comes to creating your own fonts, you're going to have to make decisions yourself about where to place your rules and lookups and what features you need to implement. Obviously a good guideline is to look around and copy what other people have done; the growing number of libre fonts on GitHub make it a very helpful source of examples for those learning to program fonts.

But while copying others is a good way to get started, it's also helpful to reason for oneself about what your font ought to do. There are two parts to being able to do this. The first is a general understanding of the OpenType Layout process and how the shaper operates, and by now you should have some awareness of this. The second is a careful look at the [feature tags list](https://docs.microsoft.com/en-us/typography/opentype/spec/featuretags) of the OpenType specification to see if any of them seem to fit what we're doing.

Let's suppose we are implementing a font for the Takri script of north-west India. There's no Script Development Standard for Takri, so we're on our own. We've designed our glyphs, but we've found a problem. When a consonant has a i-matra and an anusvara, we'd like to move the anusvara closer to the matra. So instead of:

![](localisation/takri-1.png)

we want to see:

![](localisation/takri-2.png)

We've designed a new glyph `iMatra.anusvara` which contains both the matra and the correctly-positioned anusvara, and we've written a chained contextual substitution rule:

    lookup iMatraAnusVara {
        sub iMatra by iMatra.anusvara;
        sub anusvara by emptyGlyph;
    }

    sub iMatra' lookup iMatraAnusVara @consonant' anusvara' lookup iMatraAnusVara;

This replaces the matra with our matra-plus-anusvara form, and replaces the old anusvara with an empty glyph. Nice. But what feature does it belong in?

First, we decide what 
XXX list of (implemented) OT features - how do you know which feature to use?
(Refer to localization chapter)

### Superscript / Subscript

XXX

### Stylistic Alternates

XXX

### Contextual Alternates

XXX

### Positioning

XXX

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

