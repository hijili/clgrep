# clgrep
grep command for changelog memo
  
(but ignore original grep options...)

## Overview

for example : clmemo01.txt

    2010-01-01 Wed. @hijili2 <hoge_fuga@noexist.com>
    
        * Test01-01: test01 element 1h
                Hello World
    
        * Test01-02: test02 element
                Good evening world 35m
     
                Good night world 15m
    
    2009-12-31 Tue. @hijili2 <hoge_fuga@noexist.com>
    
        * Test02-01: test03 element

grep part including "world"
  
    $ clgrep -i world clmemo01.txt 
        * Test01-01: test01 element 1h
                Hello World
    
        * Test01-02: test02 element
                Good evening world 35m
    
                Good night world 15m

output report style, and then totalize time at end of line

    $ clgrep -r -i world clmemo01.txt 
    2010-01-01 Wed. @hijili2 <hoge_fuga@noexist.com>
        * Test01-01: test01 element 60m
        * Test01-02: test02 element 50m


## Requirement

Perl > 5.8

## Usage

    $ clgrep -h
    Usage: /usr/local/bin/clgrep [OPTIONS] PATTERN [FILE]
     parse options
      -i, --ignore-case: ignore case
      -t, --tag-only   : grep target is tag only 
      -s, --start-date : start date (YYYYMM[DD])
      -e, --end-date   : end   date (YYYYMM[DD])
    
     output options
      -w, --with-date   : output with date
      -r, --report      : output report style
      --total[ize],--csv: output totalized time summary for each tag
    
      -h, --help       : print this usage

## Install

`$ make install`
