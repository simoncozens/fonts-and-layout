---
layout: chapter
title: OpenType for Global Scripts
---

* TOC
{:toc}

In the last chapter, we looked at OpenType features from the perspective of technology: what cool things can we make the font do? In this chapter, however, we're going to look from the perspective of language: how do we make the font support the kind of language features we need? We'll be putting together the substitution and positioning lookups from OpenType Layout that we learnt about in the previous chapter, and using them to create fonts which behave correctly and beautifully for the needs of different scripts and language systems.

## Script and language handling

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

> Don't get *too* stressed out about choosing the right feature for your rules. If you put the rule in a strange feature but your font behaves in the way that you want it to, that's good enough; there is no OpenType Police who will tell you off for violating the specification. Heck, you can put substitution rules in the `kern` feature if you like, and people might look at you funny but it'll probably work fine. The only time this gets critical is when we are talking about (a) features which are selected by the user interface of the application doing the layout (for example, the `smcp` feature is usually turned on when the user asks for small caps, and it would be bizarre - and arguably *wrong* - if this also turned on additional ligatures), and (b) more complex fonts with a large number of rules which need to be processed in a specific order. Getting things in the right place in the processing chain will increase the chances of your font behaving in the way you expect it to, and, more importantly, will reduce the chances of features interacting with each other in unexpected ways.

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

First, we decide what broad category this rule should belong to. Are we rewriting the mapping between characters and glyphs? Not really. So this doesn't go in the initial "pre-shaping" feature collection. It's something that should go towards the end of the processing chain. But it's also a substitution rule rather than a positioning rule, so it should go in the substitution part of the processing chain. It's somewhere in the middle.

Second, we ask ourselves if this is something that we want the user to control or something we want to require. We'd rather it was something that was on by default. So we look through the collection of features that shapers execute by default, and go through their descriptions in the [feature tags](https://docs.microsoft.com/en-us/typography/opentype/spec/featuretags) part of the OpenType spec.

For example, we could make it a required ligature, but we're not exactly "replacing a sequence of glyphs with a single glyph which is preferred for typographic purposes." `dist` might be an option, but that's usually executed at the positioning stage. What about `abvs`, which "substitutes a ligature for a base glyph and mark that's above it"? This feature should be on by default, and is required for Indic scripts; it's normally executed near the start of the substitution phase, after those features which rewrite the input stream. This sounds like it will do the job, so we'll put it there.

Once again, this is not an exact science, and unless you are building up extremely complex fonts, it isn't going to cause you too many problems. So try to reason about what your features are doing, but feel free to copy others, and don't worry too much about it.

Now let's look at how to implement some specific features, starting with a few simple ones to get us started, and then getting to the more tricky stuff later.

## Language-specific substitutes

We've already mentioned the Serbian form of the letter be (б), which should appear different to the Russian Cyrillic version. This is one example of a family of *language-specific substitutes*, which we can handle more or less in the same way.

First, we design our two glyphs, the Russian be (let's call the glyph `be-cy`) and the Serbian variant, which we'll call `be-cy.SRB`. We want a feature which is on by default, occurs early in the process, is pre-shaping (in that it rewrites the input glyph stream) and which substitutes localized forms - this is precisely what the `locl` feature was designed for. We look up the script tag for Cyrillic (`cyrl`) and the language tag for Serbian (`SRB`), and we create a rule that applies only when the input is tagged as being in the Serbian language. We want to do a one-to-one substitution - any Cyrillic be gets swapped out for a Serbian one - so we create a single substitution rule.

    feature locl {
        script cyrl;
        language SRB;
        sub be-cy by be-cy.SRB;
    } locl;

Job done.

We can apply the same kind of substitution not just to base characters but also to marks and combining characters, although we need a little thought. In Polish, there's an accent called a *kreska* which looks like an acute accent from other Latin scripts - and in fact, is expressed in Unicode as an acute accent - but is somewhat more upright and positioned to the right of the glyph. How do we create a font which distinguishes between the Western European acute accent and the Polish kreska, even though the Unicode characters are the same?

First, we should note that the Polish accent appears on some letters we may not have planned for: c, n, s and z - then again, we should also be aware that these letters also get an *acute* accent in other writing systems: Yoruba, Khmer, and Sanskrit transliteration amongst others. So we can't just rely on having the Polish forms for these. We need - as with the vowels - to create two separate versions: one with the Western European acute, and one with *kreska*. We look at [Adam Twardoch's web site](http://www.twardoch.com/download/polishhowto/kreska.html) to help get the design of our Polish accents right, and we should now end up with two sets of glyphs: `aacute`, `cacute`, ... and `aacute.PLK`, `cacute.PLK` and so on.

Now we know what we're doing: we use the `locl` feature as before to substitute in these glyphs when the input text is in Polish:

    feature locl {
        script latn;
        language PLK;
        sub [aacute cacute ...] by [aacute.PLK cacute.PLK ...];
    } locl;

> This general pattern - language-specific substitution rules in the `locl` feature - can be used for a large number of localisation customizations, particularly those based on the Latin script (simply because they tend to be one-to-one glyph replacements.) Further examples of the pattern include Navajo forms of the ogonek accent, and choosing between variants of the letter U+014A LATIN CAPITAL LETTER ENG (Ŋ) - "N-form" variants in the case of Sami languages and "n-form" variants for African ones.

### A detour about diacritics

We've looked at the mark-to-base positioning and composition/decomposition substitutions in previous chapters. Why, then, do we need to design separate glyphs for `cacute` and `cacute.PLK` - can't we just design separate *accents* and have the OpenType system tie them together for us? In fact, why do we even need to include a `cacute` in our font *at all*? Can't we just have the font automatically compose the glyph out of the c base glyph and the acute mark, and automatically position it for us? Hey, why can't we do that for *all* our diacritic characters? As with many things in life, the answer is: sure, you *can*, but that doesn't mean you *should*.

There are a few reasons why it's best to design and include precomposed forms of all the accented glyphs you're going to support, rather than rely on automatic composition. For one thing, there's kerning: it's much easier to test and edit the kerning for "Tå" in your font editor than adding tricky kern triplets in OpenType feature code.

Another problem is that some software (notably Adobe InDesign) doesn't support it, and other software doesn't support it in reliable ways. This is an important area to understand because it highlights the interplay between *OpenType*'s understanding of characters and glyphs and *Unicode*'s understanding of characters and glyphs.

Remember how we talked about [Unicode normalization and decomposition](unicode.html#normalization-and-decomposition) in chapter 3, and how you can decompose a character like é (U+00E9 LATIN SMALL LETTER E WITH ACUTE) into two characters, U+0065 LATIN SMALL LETTER E and U+0301 COMBINING ACUTE ACCENT? That sounds very similar to the idea of having an "eacute" glyph which is made up of an "e" glyph and an "acutecomb" glyph. Similar... but unfortunately different.

As it happens, if your font provides a "e" and a "acutecomb" glyph but *not* a precomposed "eacute", then some text layout systems will *only* render an e-acute if the input text is decomposed to U+0065 U+0301 (which is exceptionally rare) and will use a fallback font to display the precomposed form U+00E9. Others will automatically decompose a U+00E9 in the input stream to U+0065 U+0301 and display the two glyphs correctly. Some systems will correctly substitute a precomposed glyph for its decomposition specified using the `ccmp` feature, but then will fail to position the marks properly in the `mark` feature.

But having a precomposed glyph in the font will always work, both for composed Unicode characters like U+00E9 *and* for its decompositions, so that's why having the font contain all the glyphs you are likely to support is a better way to go.

### Problems with "i"

The letter "i" turns out to be 

Turkish i
ccmp in Selawik



## Positioning

XXX
## Arabic, Urdu and Sindhi

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

## Resources

http://theinsectsproject.eu

