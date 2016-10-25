---
layout: chapter
title: The Unicode Standard
---

When humans exchange information, we use sentences, words, and - most relevantly for our purposes - letters. But computers don't know anything about letters. Computers only know about numbers, and to be honest, they don't know much about them, either. Because computers are, ultimately, great big collections of electronic switches, they only know about two numbers: zero, if a switch is off, and one, when a switch is on.

By lining up a row of switches, we can represent bigger numbers. These days, computers normally line up eight switches in a unit, called a *byte*. With eight switches and two states for each switch, we have $$ 2^8 = 256 $$ possible states in a byte, so we can represent a number between 0 and 255. But still, everything is a number.

To move from numbers to letters and store text in a computer, we need to agree on a code. We might decide that when we're expecting text, the number 1 means "a", number 2 means "b" and so on. This mapping between numbers and characters is called an *encoding*.

In the earliest days of computers, every manufacturer had their own particular encoding, but they soon realised that data written on one system would not be able to be read on another. There was a need for computer and telecommunications manufacturers to standardize their encodings. One of the earliest and most common encodings was ASCII, the American Standard Code for Information Interchange. First standardized in 1963, this system uses seven of the eight bits (switches) in a byte, giving an available range of $$ 2^7 = 128 $$ characters.

In ASCII, the numbers from 0 to 31 are used to encode "control characters". These do not represent printable information, but give instructions to the devices which use ASCII: start a new line, delete the previous character, start transmission, stop transmission and so on. 32 is a space, and the numbers from 33 to 64 are used to represent a range of non-alphabetic symbols, including the numerals 0 to 9. The numbers from 65 to 127 encode the 26 lower case and 26 upper case letters of the English alphabet, with some more non-alphabetic symbols squeezed in the gap.

But ASCII was, as its name implies, an *American* standard, and for most of the world, 26 lower case and 26 upper case letters is - to use something of a British understatement - not going to be enough. When Europeans needed to exchange data including accented characters, or Russians needed to write files in Cyrillic, or Greeks in Greek, the ASCII standard did not allow them to do so. But on the other hand, ASCII only used seven bits out of the byte, encoding the numbers from 0 to 127. And a byte can store any number from 0 to 255, leaving 127 free code points up for grabs.

The problem, of course, is that 127 code points was not enough for the West Europeans and the Russians and the Greeks to *all* encode all of the characters that they needed. And so, as in the days of the Judges, all the people did whatever seemed right in their own eyes; every national language group developed their own encoding, jamming whatever characters that they needed into the upper half of the ASCII table. Suddenly, all of the interchange problems that ASCII was meant to solve reappeared. Someone in France might send a message asking for a *tête-à-tête*, but his Russian colleague would be left wondering what a *tЙte-Ю-tЙte* might be. But wait! It was worse than that: a Greek PC user might greet someone with a cheery Καλημέρα, but if his friend *happened to be using a Mac*, he would find himself being wished an ακγλίώα instead.

And then the Japanese showed up.

To write Japanese you need 100 syllabic characters and anything between 2,000 and 100,000 Chinese ideographs. Suddenly 127 free code points seems like a drop in the ocean. There are a number of ways that you can solve this problem, and different Japanese computer manufacturers tried all of them. The Shift JIS encoding used two bytes (16 bits, so $$ 2^{16} = 65536 $$ different states) to represent each character; EUC-JP used a variable number of bytes, with the first byte telling you how many bytes in a character; ISO-2022-JP used magic "escape sequences" of characters to jump between ASCII and JIS. Files didn't always tell you what encoding they were using, and so it was a very common experience in Japan to open up a text file and be greeted with a screen full of mis-encoded gibberish. (The Japanese for "mis-encoded gibberish" is *mojibake*.)

Clearly there was a need for a new encoding; one with a broad enough scope to encode *all* the world's characters, and one which could unify the proliferation of local "standards" into a single, global information processing standard. That encoding is Unicode.

In 1984, the International Standards Organisation began the task of developing such a global information processing standard. You may sometimes hear Unicode referred to as ISO 10646, which is sort of true. In 1986, developers from Apple and Xerox began discussing a proposed encoding system which they referred to as Unicode. The Unicode working group expanded and developed in parallel to ISO 10646, and in 1991 became formally incorporated as the Unicode Consortium and publishing Unicode 1.0. At this point, ISO essentially gave up trying to do their own thing.

This doesn't mean that ISO 10646 is dead. Instead, ISO 10646 is a formal international standard definition of a Universal Coded Character Set, also known as UCS. The UCS is deliberately synchronised with the character-to-codepoint mapping defined in the Unicode Standard, but the work remains formally independent. At the same time, the Unicode Standard defines more than just the character set; it also defines a wide range of algorithms, data processing expectations and other advisory information about dealing with global scripts.

## Global Scripts in Unicode

At the time of writing, the Unicode Standard is up to version 9.0, and new scripts and characters are being encoded all the time. The Unicode character set is divided into 17 planes, each covering 65536 code points, for a total of 1,114,112 possible code points. Currently, only 128,327 of those code points have been assigned characters; 137,468 code points (including the whole of the last two planes) are reserved for private use.

> Private use means that *within an organisation, community or system* you may use these code points to encode any characters you see fit. However, private use characters should not "escape" into the outside world. Some organisations maintain registries of characters they have assigned to private use code points; for example, the SIL linguistic community have encoded 248 characters for their own use. One of these is , LATIN LETTER SMALL CAPITAL L WITH BELT, which they have encoded at position U+F268. But there's nothing to stop another organisation assigning a *different* character to U+F268 within their systems. If allocations start clashing, you lose the whole point of using a common universal character set. So use private use characters... privately.

Most characters live in the first plane, Plane 0, otherwise known as the Basic Multilingual Plane. The BMP is pretty full now - there are only 128 code points left unallocated - but it covers almost all languages in current use. Plane 1 is called the Supplementary Multilingual Plane, and mainly contains historic scripts, symbols and emoji. Lots and lots of emoji. Plane 2 contains extended CJK (Chinese, Japanese and Korean) ideographs with mainly rare and historic characters, while planes 3 through 13 are currently completely unallocated. So Unicode still has a lot of room to grow.

Within each plane, Unicode allocates each writing system a range of codepoints called a block. Blocks are not of fixed size, and are not exhaustive - once codepoints are allocated, they can't be moved around, so if new characters from a writing system get added and their block fills up, a separate block somewhere else in the character set will be created. For instance, groups of Latin-like characters have been added on multiple occasions. This means that there are now 17 blocks allocated for different Latin characters; one of them, Latin Extended-B, consists of 208 code points, and contains Latin characters such as Ƕ (Latin Capital Letter Hwair), letters used in the transcription of Pinyin, and African clicks like U+013C, ǃ - which may look a lot like an exclamation mark but is actually the ǃKung letter Latin Letter Retroflex Click.

> The distinction between ǃ (Retroflex Click) and ! (exclamation mark) illustrates a fundamental principle of Unicode: encode what you mean, not what you see. If we were to use the exclamation mark character for both uses just because they were visually identical, we would sow semantic confusion. Keeping the code points separate keeps your data unambiguous.

Here is the complete list of scripts already encoded in Unicode as of version 9.0: Adlam, Ahom, Anatolian Hieroglyphs, Arabic, Armenian, Avestan, Balinese, Bamum, Bassa Vah, Batak, Bengali, Bhaiksuki, Bopomofo, Brahmi, Braille, Buginese, Buhid, Canadian Aboriginal, Carian, Caucasian Albanian, Chakma, Cham, Cherokee, Common (that is, characters used in multiple scripts), Coptic, Cuneiform, Cypriot, Cyrillic, Deseret, Devanagari, Duployan, Egyptian Hieroglyphs, Elbasan, Ethiopic, Georgian, Glagolitic, Gothic, Grantha, Greek, Gujarati, Gurmukhi, Han (that is, Chinese, Japanese and Korean ideographs), Hangul, Hanunoo, Hatran, Hebrew, Hiragana, Imperial Aramaic, Inscriptional Pahlavi, Inscriptional Parthian, Javanese, Kaithi, Kannada, Katakana, Kayah Li, Kharoshthi, Khmer, Khojki, Khudawadi, Lao, Latin, Lepcha, Limbu, Linear A, Linear B, Lisu, Lycian, Lydian, Mahajani, Malayalam, Mandaic, Manichaean, Marchen, Meetei Mayek, Mende Kikakui, Meroitic Cursive, Meroitic Hieroglyphs, Miao, Modi, Mongolian, Mro, Multani, Myanmar, Nabataean, New Tai Lue, Newa, Nko, Ogham, Ol Chiki, Old Hungarian, Old Italic, Old North Arabian, Old Permic, Old Persian, Old South Arabian, Old Turkic, Oriya, Osage, Osmanya, Pahawh Hmong, Palmyrene, Pau Cin Hau, Phags Pa, Phoenician, Psalter Pahlavi, Rejang, Runic, Samaritan, Saurashtra, Sharada, Shavian, Siddham, SignWriting, Sinhala, Sora Sompeng, Sundanese, Syloti Nagri, Syriac, Tagalog, Tagbanwa, Tai Le, Tai Tham, Tai Viet, Takri, Tamil, Tangut, Telugu, Thaana, Thai, Tibetan, Tifinagh, Tirhuta, Ugaritic, Vai, Warang Citi, Yi.

What should you do if you are developing resources for a script which is not encoded in Unicode? Well, first you should check whether or not it has already been proposed for inclusion by looking at the [Proposed New Scripts](http://www.unicode.org/pending/pending.html) web site; if not, then you should contact the Unicode mailing list to see if anyone is working on a proposal; then you should contact the [Script Encoding Initiative](http://linguistics.berkeley.edu/sei/), who will help to guide you through the process of preparing a proposal to the Unicode Technical Committee. This is not a quick process; some scripts have been in the "preliminary stage" for the past ten years, while waiting to gather expert opinions on their encoding.

## How data is stored

When computers store data in eight-bit bytes, representing numbers from 0 to 255, and your character set contains fewer than 255 characters, everything is easy. A character fits within a byte, so each byte in a file represents one character. One number maps to one letter, and you're done.

But when your character set has a potential 1,112,064 code points, you need a strategy for how you're going to store those code points in bytes of eight bits. This strategy is called a *character encoding*, and the Unicode Standard defines three of them: UTF-8, UTF-16 and UTF-32. (UTF stands for *Unicode Transformation Format*, because you're transforming code points into bytes and vice versa.)

> There are a number of other character encodings in use, which are not part of the Standard, such as UTF-7, UTF-EBCDIC and the Chinese Unicode encoding GB18030. If you need them, you'll know about it.

The names of the character encodings reflect the number of bits used in encoding. It's easiest to start with UTF-32: if you take a group of 32 bits, you have $$ 2^{32} = 4,294,967,296 $$ possible states, which is more than sufficient to represent every character that's ever likely to be in Unicode. Every character is represented as a group of 32 bits, stretched across four 8-bit bytes. To encode a code point in UTF-32, just turn it into binary, pad it out to four bytes, and you're done.

For example, the character 🎅 (FATHER CHRISTMAS) lives in Finland, just inside the Arctic circle, and in the Unicode Standard, at codepoint 127877. In binary, this is 11111001110001111, which we can encode in four bytes using UTF-32 as follows:

|---
| |
|-------|--------|--------:|--------:|--------:|
|Binary |         |       1|11110011|10001111|
|Padded | 00000000|00000001|11110011|10001111|
|Hex    |       00|      01|      F3|      85|
|Decimal|        0|       1|     243|     133|
|-------|--------|--------|--------|--------|


> There's only one slight complication: whether the bytes should appear in the order `00 01 F3 85` or in reverse order `85 F3 01 00`. By default UTF-32 stores data "big-end first" (`00 01 F3 85`) but some systems prefer to put the "little-end" first. They let you know that they're doing this by encoding a special character (ZERO WIDTH NO BREAKING SPACE) at the start of the file. How this character is encoded tells you how the rest of the file is laid out. When ZWNBS is used in this way, it's called a BOM - Byte Order Mark - and is not interpreted as the first character of a document.

### UTF-16

UTF-32 is a very simple and transparent encoding - four bytes is one character, always, and one character is always four bytes - so it's often used as a way of processing Unicode data inside of a program. Many programming languages already allow you to read and write numbers that are four bytes long, so representing Unicode code points as numbers isn't a problem. (A "wide character", in languages such as C or Python, is a 32-bit wide data type, ideal for processing UTF-32 data.)
But UTF-32 is not very efficient. The first byte is always going to be zero, and the top seven bits of the second byte are going to be zero too. So UTF-32 is not often used as an on-disk storage format: we don't like the idea of spending nearly 50% of our disk space on bytes that are guaranteed to be empty.

So can we find a compromise where we use fewer bytes but still represent the majority of characters we're likely to use, in a relatively straightforward way? UTF-16 uses a group of 16 bits (2 bytes) instead of 32, on the basis that the first two bytes of UTF-32 are almost always unused. UTF-16 simply drops those upper two bytes, and instead uses two bytes to represent the Unicode characters from 0 to 65535, the characters within the Basic Multilingual Plane. This worked fine for the majority of characters that people were likely to use. (At least, before emoji inflicted themselves upon the world.) If you want to encode the Thai letter *to pa-tak* (ฏ) which lives at code point 3599 in the Unicode standard, we write 3599 in binary: `0000111000001111` and get two bytes `0E 0F`, and that's the UTF-32 encoding.

> From now on, we'll represent Unicode codepoints in the standard way: the prefix `U+` to signify a Unicode codepoint, and then the codepoint in hexadecimal. So *ta pa-tak* is U+0E0F.

But what if, as in the case of FATHER CHRISTMAS, we want to access code points above 65535? This is where the compromise comes in: to make it easy and efficient to represent characters in the BMP, UTF-16 gives up the ability to easily and efficiently represent characters outside that plane. Instead, it uses a mechanism called *surrogate pairs* to encode a character from the supplementary planes. A surrogate pair is a 2-byte sequence that looks like it ought to be a valid Unicode character, but is actually from a reserved range which represents a move to another plane. So  UTF-16 uses 16 bits for a character inside the BMP, but two 16 bit sequences for those outside; in other words, UTF-16 is *generally* a fixed-width encoding, but in certain circumstances a character can be either two or four bytes.

Surrogate pairs work like this:

* First, subtract `0x010000` from the code point you want to encode. Now you have a 20 bit number.

* Split the 20 bit number into two 10 bit numbers. Add `0xD800` to the first, to give a number in the range `0xD800..0xDBFF`. Add `0xDC00` to the second, to give a number in the range `0xDC00..0xDFFF`. These are your two 16-bit code blocks.

So for FATHER CHRISTMAS, we start with U+1F385.

* Take away `0x010000` to get `F385`, or `00001111001110000101`.

* Split this into `0000111100 1110000101` or `03C 385`.

* `0xD800` + `0x03C` = `D83C`

* `0xDC00` + `0x385` = `DF85`.

So FATHER CHRISTMAS in UTF-16 is `D8 3C DF 85`.

> Because most characters in use are in the BMP, and because the surrogate pairs *could* be interpreted as Unicode code points, some software may not bother to interpret surrogate pair processing. I suppose we should be grateful that emoji has forced programmers to be more aware of supplemental planes.

### UTF-8

But UTF-16 still uses *two whole bytes* for every ASCII and Western European Latin character, which sadly are the only characters that any programmers actually care about. So of course, that would never do.

UTF-8 takes the trade-off introduced by UTF-16 a little further: characters in the ASCII set are represented as single bytes, just as they were originally in ASCII, while code points above 127 are represented using a variable number of bytes: codepoints from `0x80` to `0x7FF` are two bytes, from `0x800` to `0xffff` are three bytes, and higher characters are four bytes.

The conversion is best done by an existing computer program or library - you shouldn't have to do UTF-8 encoding by hand - but for reference, this is what you do. First, work out how many bytes the encoding is going to need, based on the Unicode code point. Then, convert the code point to binary, split it up and insert it into the pattern below, and pad with leading zeros:

|---
| Code point | Byte 1 | Byte 2 | Byte 3 | Byte 4 |
|-------|-------:|--------:|--------:|--------:|
|`0x00-0x7F`|`0xxxxxxx`|
|`0x80-0x7FF`|`110xxxxx`|`10xxxxxx`|
|`0x800-0xFFFF`|`1110xxxx`|`10xxxxxx`|`10xxxxxx`|
|`0x10000-0x10FFFF`|`11110xxx`|`10xxxxxx`|`10xxxxxx`|`10xxxxxx`|
|-------|-------|--------|--------|--------|

> Originally UTF-8 allowed sequences up to seven bytes long to encode characters all the way up to `0x7FFFFFFF`, but this was restricted when UTF-8 became an Internet standard to match the range of UTF-16. Once we need to encode more than a million characters in Unicode, UTF-8 will be insufficient. However, we are still some way away from that situation.

FATHER CHRISTMAS is going to take four bytes, because he is above `0x10000`. The binary representation of his codepoint U+1F385 is `11111001110000101`, so, inserting his bits into the pattern from the right, we get:

|---
||||
|-------|-------:|--------:|--------:|--------:|
|`0x1000-0x10FFFF`|`11110xxx`|`10x`**`11111`**|`10`**`001110`**|`10`**`000101`**|
|-------|-------|--------|--------|--------|

Finally, padding with zeros, we get:

|---
||||
|-------:|--------:|--------:|--------:|
|`11110`**`000`**|`10`**`011111`**|`10`**`001110`**|`10`**`000101`**|
|`F0`|`9F`|`8E`|`85`|
|-------|--------|--------|--------|

UTF-8 is not a bad trade-off. It's variable width, which means more work to process, but the benefit of that is efficiency - characters don't take up any more bytes than they need to. And the processing work is mitigated by the fact that the initial byte signals how long the byte sequence is. The leading bytes of the sequence also provide an unambiguous synchronisation point for processing software - if you don't recognise where you are inside a byte stream, just back up a maximum of four characters until you see a byte starting `0`, `110`, `1110` or `11110` and go from there.

Because of this, UTF-8 has become the *de facto* encoding standard of the Internet, with around 90% of web pages using it. If you have data that you're going to be shaping with an OpenType shaping engine, it's most likely going to begin in UTF-8 before being transformed to UTF-32 internally.

## Character properties

The Unicode Standard isn't merely a collection of characters and their code points. The standard also contains the Unicode Character Database, a number of core data files containing the information that computers need in order to correctly process those characters. For example, the main database file, `UnicodeData.txt` contains a `General_Category` property which tells you if a codepoint represents a letter, number, mark, punctuation character and so on.

Let's pick a few characters and see what Unicode says about them. We'll begin with codepoint U+0041, the letter `A`. First, looking in `UnicodeData.txt` we see

    0041;LATIN CAPITAL LETTER A;Lu;0;L;;;;;N;;;;0061;

After the codepoint and official name, we get the general category, which is `Lu`, or "Letter, uppercase." The next field, 0, is useful when you're combining and decomposing characters, which we'll look at later. The `L` tells us this is a strong left-to-right character, which is of critical importance when we look at bidirectionality in later chapters. Otherwise, `UnicodeData.txt` doesn't tell us much about this letter - it's not a character composed of multiple characters stuck together and it's not a number, so the next three fields are blank. The `N` means it's not a character that mirrors when the script flips from left to right (like parentheses do between English and Arabic. The next two fields are no longer used. The final fields are to do with upper and lower case versions: Latin has upper and lower cases, and this character is simple enough to have a single unambiguous lower case version, codepoint U+0061. It doesn't have upper or title case versions, because it already is upper case, duh.

What else do we know about this character? Looking in `Blocks.txt` we can discover that it is part of the range, `0000..007F; Basic Latin`. `LineBreak.txt` is used by the line breaking algorithm, something we'll also look at in the chapter on layout.

    0041..005A;AL     # Lu    [26] LATIN CAPITAL LETTER A..LATIN CAPITAL LETTER Z

This tells us that the upper case A is an alphabetic character for the purposes of line breaking. `PropList.txt` is a rag-tag collection of Unicode property information, and we will find two entries for our character there:

    0041..0046    ; Hex_Digit # L&   [6] LATIN CAPITAL LETTER A..LATIN CAPITAL LETTER F
    0041..0046    ; ASCII_Hex_Digit # L&   [6] LATIN CAPITAL LETTER A..LATIN CAPITAL LETTER F

These tell us that it is able to be used as a hexadecimal digit, both in a more relaxed sense and strictly as a subset of ASCII. (U+FF21, a full-width version of `Ａ` used occasionally when writing Latin characters in Japanese text, is a hex digit, but it's not an ASCII hex digit.) `CaseFolding.txt` tells us:

    0041; C; 0061; # LATIN CAPITAL LETTER A

When you want to case-fold a string containing `A`, you should replace it with codepoint `0061`, which as we've already seen, is LATIN SMALL LETTER A. Finally, in `Scripts.txt`, we discover...

    0041..005A    ; Latin # L&  [26] LATIN CAPITAL LETTER A..LATIN CAPITAL LETTER Z

...that this codepoint is part of the Latin script. You knew that, but now a computer does too.

Now let's look at a more interesting example. N'ko is a script used to write the Mandinka and Bambara languages of West Africa. But if we knew nothing about it, what could the Unicode Character Database teach us? Let's look at a sample letter, U+07DE NKO LETTER KA (ߞ).

First, from `UnicodeData.txt`:

    07DE;NKO LETTER KA;Lo;0;R;;;;;N;;;;;

This tells me that the character is a Letter-other - neither upper nor lower case - and the lack of case conversion information at the end confirms that N'ko is a unicase script. The `R` tells me that N'ko is written from right to left, like Hebrew and Arabic. It's an alphabetic character for line breaking purposes, according to `LineBreak.txt`, and there's no reference to it in `PropList.txt`. But when we look in `ArabicShaping.txt` we find something very interesting:

    07DE; NKO KA; D; No_Joining_Group

The letter ߞ is a double-joining character, meaning that N'ko is a connected script like Arabic, and the letter Ka connects on both sides. That is, in the middle of a word like "n'ko" ("I say"), the letter looks like this: ߒߞߏ.

This is the kind of data that text processing systems can derive programmatically from the Unicode Character Database. Of course, if you really want to know about how to handle N'ko text and the N'ko writing system in general, the Unicode Standard itself is a good reference point: its section on N'ko (section 19.4) tells you about the origins of the script, the structure, diacritical system, punctuation, number systems and so on. When dealing with computer processing of an unfamiliar writing system, the Unicode Standard is often a great place to start.

## Case conversion

A tiny minority of writing systems, such as those based on the Latin alphabet, have the concept of upper and lower case versions of a character. 

## Normalization and decomposition

## ICU
