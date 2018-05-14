# Clauses

A collection of useful legal clauses for coding consultants or employees to put into their contracts. Written and/or solicited by <a href="http://alexchaffee.com">Alex Chaffee</a>. Available at <https://github.com/alexch/clauses>.

Disclaimer: I AM NOT A LAWYER. You should run all this by your own legal counsel.

## Setup

### MacOS:
```
brew install caskroom/cask/wkhtmltopdf
bundle install
```

## Automatic contract generation

1. write a contract using [Markdown](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
2. use [`{{mustache}}`](https://mustache.github.io/) inside your document's body
3. set variables in your document's header (a bunch of `name:value` lines, terminated with a blank line)
4. run them through `process.rb` like this:

  ./process.rb contract.md

and like magic, a PDF version will appear!

## License

<p xmlns:dct="http://purl.org/dc/terms/">
  <a rel="license"
     href="http://creativecommons.org/publicdomain/zero/1.0/">
    <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
  </a>
  <br />
  To the extent possible under law,
  <span resource="[_:publisher]" rel="dct:publisher">
    <span property="dct:title">Alexander D. Chaffee</span></span>
  has waived all copyright and related or neighboring rights to
  <span property="dct:title">Clauses</span>.
</p>

## Similar Projects

* <https://gist.github.com/postmodern/3242224>
* <https://stuffandnonsense.co.uk/projects/contract-killer/>
* <http://www.docracy.com/>


