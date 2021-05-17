ls ./templates/*.php | xargs grep -Po 'class=\"(([a-z]|-| |[0-9])*)\"' >> used-classes.txt

sort -r used-classes.txt | uniq -d