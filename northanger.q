/ northanger abbey
northanger.f:"121.txt"
northanger.b:"http://www.gutenberg.org/files/121/"
-1"[down]loading northanger abbey text";
.util.download[northanger.b;;"";""] northanger.f;
northanger.txt:read0 `$northanger.f
northanger.chapters:"\n\n\n\nCHAPTER " vs "\n" sv  58_-373_northanger.txt
northanger.s:{first[x ss"\n\n"]_x} each northanger.chapters
