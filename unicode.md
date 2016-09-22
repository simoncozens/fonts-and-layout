The Unicode Standard
====================

When humans exchange information, we use sentences, words, and - most relevantly for our purposes - letters. But computers don't know anything about letters. Computers only know about numbers, and to be honest, they don't know much about them, either. Because computers are, ultimately, great big collections of electronic switches, they only know about two numbers: zero, if a switch is off, and one, when a switch is on.

By lining up a row of switches, we can represent bigger numbers. These days, computers normally line up eight switches in a unit, called a *byte*. With eight switches and two states for each switch, we have $2^8 = 256$ possible states in a byte, so we can represent a number between 0 and 255. But still, everything is a number.

To move from numbers to letters and store text in a computer, we need to agree on a code. We might decide that when we're expecting text, the number 1 means "a", number 2 means "b" and so on. This mapping between numbers and characters is called an *encoding*.

In the earliest days of computers, every manufacturer had their own particular encoding, but they soon realised that data written on one system would not be able to be read on another. There was a need for computer and telecommunications manufacturers to standardize their encodings. One of the earliest and most common encodings was ASCII, the American Standard Code for Information Interchange. First standardized in 1963, this system uses seven of the eight bits (switches) in a byte, giving an available range of 128 characters.

In ASCII, the numbers from 0 to 31 represent "control characters". These do not represent printable information, but give instructions to the devices which use ASCII: start a new line, delete the previous character, start transmission, stop transmission and so on. 32 is a space, and the numbers from 33 to 64 are used to represent a range of non-alphabetic symbols, including the numerals 0 to 9. The numbers from 65 to 127 encode the 26 lower case and 26 upper case letters of the English alphabet, with some more non-alphabetic symbols squeezed in the gap.

But ASCII was, as its name implies, an *American* standard, and for most of the world, 26 lower case and 26 upper case letters is - to use something of a British understatement - not going to be enough. When Europeans needed to exchange data including accented characters, or Russians needed to write files in Cyrillic, or Greeks in Greek, the ASCII standard did not allow them to do so. But on the other hand, ASCII only used seven bits out of the byte, encoding the numbers from 0 to 127. And a byte can store any number from 0 to 255, leaving 127 free code points up for grabs.

The problem, of course, is that 127 code points was not enough for the West Europeans and the Russians and the Greeks to *all* encode all of the characters that they needed. And so, as in the days of the Judges, all the people did whatever seemed right in their own eyes; every national language group developed their own encoding, jamming whatever characters that they needed into the upper half of the ASCII table. Suddenly, all of the interchange problems that ASCII was meant to solve reappeared. Someone in France might send a message asking for a *tête-à-tête*, but his Russian colleague would be left wondering what a *tЙte-Ю-tЙte* might be. But wait! It was worse than that: a Greek PC user might greet someone with a cheery Καλημέρα, but if his friend *happened to be using a Mac*, he would find himself being wished an ακγλίώα instead.

And then the Japanese showed up.

To write Japanese you need 100 syllabic characters and anything between 2,000 and 100,000 Chinese ideographs. Suddenly 127 free code points seems like a drop in the ocean. There are a number of ways that you can solve this problem, and different Japanese computer manufacturers tried all of them. The Shift JIS encoding used two bytes (16 bits, so 65536 different states) to represent each character; EUC-JP used a variable number of bytes, with the first byte telling you how many bytes in a character; ISO-2022-JP used magic "escape sequences" of characters to jump between ASCII and JIS. Files didn't always tell you what encoding they were using, and so it was a very common experience in Japan to open up a text file and be greeted with a screen full of mis-encoded gibberish. (The Japanese for "mis-encoded gibberish" is *mojibake*.)

Clearly there was a need for a new encoding; one with a broad enough scope to encode *all* the world's characters, and one which could unify the proliferation of local "standards" into a single, global information processing standard. That encoding is Unicode.

XXX History
XXX Unicode v ISO 10646 - UCS

## Languages in Unicode

## How data is stored

When computers store data in eight-bit bytes, representing numbers from 0 to 255, and your character set contains fewer than 255 characters, everything is easy. A character fits within a byte, so each byte in a file represents one character. One number maps to one letter, and you're done.

But when your character set has a potential 1,112,064 code points, you need a strategy for how you're going to store those code points in bytes of eight bits. This strategy is called a *character encoding*, and the Unicode Standard defines three of them: UTF-8, UTF-16 and UTF-32. (UTF stands for *Unicode Transformation Format*, because you're transforming code points into bytes and vice versa.)

> There are a number of other character encodings in use, which are not part of the Standard, such as UTF-7, UTF-EBCDIC and the Chinese Unicode encoding GB18030. If you need them, you'll know about it.

The names of the character encodings reflect the number of bits used in encoding. It's easiest to start with UTF-32: if you take a group of 32 bits, you have $2^32 = 4,294,967,296$ possible states, which is more than enough to represent every character that's ever likely to be in Unicode. Every character is represented as a group of 32 bits, stretched across four 8-bit bytes. To encode a code point in UTF-32, just turn it into binary, pad it out to four bytes, and you're done.

For example, the character 🎅 (FATHER CHRISTMAS) lives in Finland, just inside the Arctic circle, and in the Unicode Standard, at codepoint 127877. In binary, this is 11111001110001111, which we can encode in four bytes using UTF-32 as follows:

-------  -------- -------- -------- --------
Binary                   1 11110011 10001111
Padded   00000000 00000001 11110011 10001111
Hex            00       01       F3       85
Decimal         0        1      243      133
-------  -------- -------- -------- --------

> There's only one slight complication: whether the bytes should appear in the order `00 01 F3 85` or in reverse order `85 F3 01 00`. By default UTF-32 stores data "big-end first" (`00 01 F3 85`) but some systems prefer to put the "little-end" first. They let you know that they're doing this by encoding a special character (ZERO WIDTH NO BREAKING SPACE) at the start of the file. How this character is encoded tells you how the rest of the file is laid out. When ZWNBS is used in this way, it's called a BOM - Byte Order Mark.

UTF-32 is a very simple and transparent encoding - four bytes is one character, always, and one character is always four bytes - so it's often used as a way of processing Unicode data inside of a program. Many programming languages already allow you to read and write numbers that are four bytes long, so representing Unicode code points as numbers isn't a problem. (A "wide character", in languages such as C or Python, is a 32-bit wide data type, ideal for processing UTF-32 data.)
But UTF-32 is not very efficient. The first byte is always going to be zero, and the top seven bits of the second byte are going to be zero too. So UTF-32 is not often used as an on-disk storage format: we don't like the idea of spending nearly 50% of our disk space on bytes that are guaranteed to be empty.

So can we find a compromise where we use fewer bytes but still represent the majority of characters we're likely to use, in a relatively straightforward way? UTF-16

## Character properties

## Case conversion

## Normalization and decomposition