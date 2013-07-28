#!/bin/sh

# Combine header, footer, and chapters,
# make anchor tags point to inside ones,
# and create a book named 'book.html'.

VERSION="?version=4.0"
#VERSION=""

echo "" >  book_fragment.html
for chapter in `cat chapter_list.txt`
do
    cat "$chapter"_fragment.html | \
	sed -e "s/id=\"top\"/class=\"label\" id=\"cha-$chapter\"/g" | \
	perl -pe "s/<\/div><div class=\"footnotes\">/<\/div>\n<div class=\"footnotes\">/g" | \
	sed -n '/<div class="navigation">/,/^<\/div>/!p' | \
	sed -e "s/href=\"\/chapters\//href=\"\/book\/ruby-on-rails-tutorial/g" \
	>> book_fragment.html
done
echo "Created 'book_fragment.html'"

# Make anchor tags point to the corresponding ones inside a book.
cp book_fragment.html book_fragment.modified_0.html
i=0
for chapter in `cat chapter_list.txt`
do
    cat book_fragment.modified_$i.html | \
	sed -e "s/$chapter$VERSION#top/$VERSION#cha-$chapter/g" | \
	sed -e "s/$chapter$VERSION/$VERSION/g" | \
	sed -e "s/book\/ruby-on-rails-tutorial$chapter\.html/book\/ruby-on-rails-tutorial/g" \
	> book_fragment.modified_`expr $i + 1`.html
    rm  book_fragment.modified_$i.html
    i=`expr $i + 1`
done
mv book_fragment.modified_$i.html book_fragment.html
echo "Corrected 'book_fragment.html'"

# Create a 'book.html'
cat _head.html                  >  book.html
cat _contents_for_book.html.erb >> book.html
cat book_fragment.html          >> book.html
cat _foot.html                  >> book.html
echo "Created 'book.html'"    