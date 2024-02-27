git clone https://github.com/tree-sitter/tree-sitter-go
git clone https://github.com/tree-sitter/tree-sitter-javascript
git clone https://github.com/tree-sitter/tree-sitter-python
git clone https://github.com/tree-sitter/tree-sitter-ruby
git clone https://github.com/tree-sitter/tree-sitter-php
git clone https://github.com/tree-sitter/tree-sitter-java
git clone https://github.com/tree-sitter/tree-sitter-c-sharp
cp -r tree-sitter-php/php/src tree-sitter-php/src
cp tree-sitter-php/src/scanner.c tree-sitter-php/src/scanner.c.orig
echo '#include "../common/scanner.h"' > tree-sitter-php/src/scanner.c
cat tree-sitter-php/src/scanner.c.orig | tail -n+2 >> tree-sitter-php/src/scanner.c
python3.10 build.py
