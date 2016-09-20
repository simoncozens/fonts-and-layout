CHAPTERS=history.md concepts.md unicode.md opentype.md features.md localisation.md adv-features.md layout.md hint.md web.md freetype.md harfbuzz.md raqm.md

html: $(CHAPTERS)
	pandoc -c pandoc.css -s -S --toc -t html5 $(CHAPTERS) > book.html