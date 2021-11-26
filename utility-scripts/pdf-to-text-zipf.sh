// Adapted from: https://stackoverflow.com/questions/7719499/print-contents-of-a-pdf-to-the-command-line
// Adapted from: https://www.youtube.com/watch?v=WYO8Rc4JB_Y&list=WL&index=4
pdftotext mydoc.pdf - | tr '[A-Z' '[a-z]' | tr -C '[a-z]' '\n' | sort | uniq -c | sort -rn