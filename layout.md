Layout Challenges
=================

The previous chapters have been mainly aimed at font designers, but with some nods to those implementing shaping and layout systems. In this second half of the book, our discussion will be mainly aimed at font *consumers* - shapers, layout engines, and applications - rather than font producers, but with some nods to font designers.

As I may have mentioned once or twice by this point, the historical development of computers and the way that text has been handled has prioritized Latin assumptions about text layout. In the Latin model, things are very simple: a glyph is a square box, you line up each of the square boxes in your string of glyphs next to each other on a horizontal line in left to right order until they more or less fit on a line, you break the line at a space, and then you (possibly) make some adjustments to the line to make it fit nicely, and finally you move onto the next line which is underneath the previous one.

But every single one of those assumptions fails in one or other script around the world. Telugu boxes don't line up next to each other. Hebrew boxes don't go left to right. Japanese boxes sometimes line up on a vertical line, sometimes on a horizontal one. Nastaleeq boxes don't line up on a perpendicular line at all. Thai lines don't break at spaces. The next line in Mongolian is to the right of the previous one, not underneath it; but in Japanese it's to the left.

What we want to do in this chapter is gain a more sophisticated understanding of the needs of complex scripts as they relate to text layout, and think about how to cater for these needs.

## Bidirectionality
## Other directionality (vertical etc.)
## Shaping challenges (Bengali etc.)
## Arabic connection
## Line breaking & word detection
### CJK
### South Asian scripts
