---
layout: chapter
title: Layout and Complex Text Processing
---

The previous chapters have been mainly aimed at font designers, but with some nods to those implementing shaping and layout systems. In this second half of the book, our discussion will be mainly aimed at font *consumers* - shapers, layout engines, and applications - rather than font producers, but with some nods to font designers.

As I may have mentioned once or twice by this point, the historical development of computers and the way that text has been handled has prioritized Latin assumptions about text layout. In the Latin model, things are very simple: a glyph is a square box, you line up each of the square boxes in your string of glyphs next to each other on a horizontal line in left to right order until they more or less fit on a line, you break the line at a space, and then you (possibly) make some adjustments to the line to make it fit nicely, and finally you move onto the next line which is underneath the previous one.

But every single one of those assumptions fails in one or other script around the world. Telugu boxes don't line up next to each other. Hebrew boxes don't go left to right. Japanese boxes sometimes line up on a vertical line, sometimes on a horizontal one. Nastaleeq boxes don't line up on a perpendicular line at all. Thai lines don't break at spaces. The next line in Mongolian is to the right of the previous one, not underneath it; but in Japanese it's to the left.

What we want to do in this chapter is gain a more sophisticated understanding of the needs of complex scripts as they relate to text layout, and think about how to cater for these needs.

## Bidirectionality

Let's begin with the idea that the boxes are lined up left to right. Clearly, in scripts like Hebrew and Arabic, that's not correct: they go right to left. Hebrew and Arabic between them have half a billion users, so supporting right-to-left text isn't really optional, but what about other scripts?

There are a number of other scripts in the Semitic family - some living, such as Mandaic, and others which are mainly of historic interest, such as Samaritan, Phoenician and Lydian; then there are scripts like N'Ko, which represents a Mande language of West Africa but whose design was heavily influenced by Arabic, and Adlam, a recently constructed script for Fulani. The point is, you can't just check if a text is Hebrew or Arabic to see if it needs special processing - you need (as with everything) to check the Unicode Character Database instead, which has a field for each character's directionality.

When you have determined that a text is actually in a right-to-left script, what special processing is needed? Unfortunately, it is not just as simple as flipping the direction and taking away numbers from the X coordinate instead of adding them. The reasons for this is that, while handling *directionality* is conceptually simple, the problems come when you have to handle *bidirectionality* (often called *bidi*): documents containing text in more than one direction. That might sound obscure, but it's actually exceptionally common. A document in Arabic may refer to the name of a foreign person or place, and do so in Latin script. Or a document like this in English might be deliberately refer to some text in العربية. When this happens, just flipping the direction has disastrous results:

![](layout/bidi-fail.png)

"I know," you might think, "I'll just work out how long the Arabic bit is, move the cursor all the way to the end of it, and then work backwards from there." But of course *that* won't work either, because there might be a line break in the middle. Worse still, line breaks do *interesting* things to bidirectional texts. The following example shows the same text, "one two שלוש (three) ארבע (four) five", set at two different line widths:

![](layout/bidi-12345.png)

Notice how the word "שלוש (three)" appears as the *second* Hebrew word on the wider line, and the *first* Hebrew word on the narrower line? This is because we're thinking left to right; if you think about the lines from right to left, it's the first Hebrew word each time.

Thankfully, this is a solved problem, and the answer is the Unicode Bidirectionality Algorithm.

> I'm not going to describe how the Unicode Bidirectionality Algorithm works, because if I do you'll try and implement it yourself, which is a mistake - it's tricky, it has a lot of corner cases, and it's also a solved problem. if you are implementing text layout, you need to support bidi, and the best way to do that is to use either the [ICU Bidi library](https://unicode-org.github.io/icu-docs/apidoc/released/icu4c/ubidi_8h.html), [fribidi](https://github.com/fribidi/fribidi), or an existing layout engine which already supports bidi (such as [libraqm](https://github.com/HOST-Oman/libraqm)).

Oh, all *right*. I'll tell you a *bit* about how it works, because the process contains some important pieces of terminology that you'll need to know.

First, let's establish the concept of a *base direction*, also called a *paragraph direction*. In this document, the base direction is left to right. In a Hebrew or Arabic document, the base direction could will be right to left. The base direction will also determine how your cursor will move.

Unicode text is always stored on disk or in memory in *logical order*, which is the "as you say it" order. So the word "four" in Hebrew ארבע is always stored as aleph (א) resh (ר) bet (ב) ayin (ע). The task of the bidi algorithm is to swap around the characters in a text to convert it from its logical order into its *visual order* - the visual order being the order the characters will be written as the cursor tracks along the paragraph. The bidi algorithm therefore runs sometime after the text has been retrieved from wherever it is stored, and sometime before it is handed to whatever is going to draw it, and it swaps around the characters in the input stream so that they are in visual order. You can do this before the characters are handed to the shaper, but it's best to do it after they have been shaped - it's a bit more complicated this way, because after characters have been shaped they're no longer characters but glyph IDs, but your shaper will also tell you which position in the input stream refers to which glyph ID, so you can go back and map each glyph to characters for bidi processing purposes.

For example, in this paragraph, we have the words "Hebrew ארבע". You say (and store) the aleph first, but we want the aleph to visually appear at the end:

    Logical order: H e b r e w   ע ב ר א
    Visual order:  H e b r e w   א ר ב ע

The first step in the algorithm is to split up the input into a set of *runs* of text of the same *embedding level*. Normally speaking, text which follows the *base direction* is embedding level 0, and any text which goes the opposite direction is marked as being level 1. This is a gross simplification, however. Let's consider the case of an English paragraph which contains an Arabic quotation, which has within it a Greek aside. In terms of solving the bidirectionality problem, you could think of this as four separate runs of text:

![](layout/bidi-unembedded.png)

How Unicode defines ways of specifying that the Greek is embedded within the Arabic which is in turn embedded within the English. While it is visually equivalent to the above, this maintains the semantic distinction between the levels:

![](layout/bidi-embedding.png)

Strong and weak characters
(Mirroring)


## Other directionality (vertical etc.)
## Shaping challenges (Bengali etc.)
## Arabic connection
## Line breaking & word detection
### CJK
### South Asian scripts
