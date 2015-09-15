#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'awesome_print'

def usage
  $stderr.puts "Usage: process.rb file"
  exit 1
end

source = ARGV[0] || usage

body = source.is_a?(IO) ? source.read : File.read(source)

# parse headers
if body.each_line.first =~ /^\s+\w+:/
  headers, body = body.split("\n\n", 2)
  scope = Hash[headers.each_line.map do |line|
                 line.split(':', 2).map { |x| x.strip }
               end]
else
  scope = {}
end
ap scope


# munge weird chars
require 'htmlentities'
curlies = {
    # todo: add more curlies
    # ‘ (U+2018) LEFT SINGLE QUOTATION MARK
    # ’ (U+2019) RIGHT SINGLE QUOTATION MARK

    "\xe2\x80\x99" => '&apos;',
    "\xe2\x80\x9c" => '&#8220;',
    "\xe2\x80\x9d" => '&#8221;'
}

curlies.each_pair do |nasty, pretty|
  body.gsub!(nasty, pretty)
end


# process mustache
# https://github.com/mustache/mustache
# (should mustache come before or after markdown?)
require 'mustache'
text = Mustache.render(body, scope)


# convert markdown to HTML
require 'redcarpet'
markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                   :no_intra_emphasis => true,
                                   :tables => true,
                                   :fenced_code_blocks => true,
                                   :autolink => true,
                                   :strikethrough => true,
                                   :lax_html_blocks => false,
                                   :space_after_headers => true,
                                   :superscript => false
)
html = markdown.render(text)


# generate PDF
# todo: switch to Prawn?
# http://asciicasts.com/episodes/220-pdfkit

require 'pdfkit'
kit = PDFKit.new(html, :page_size => 'Letter')
kit.stylesheets << "contract-style.css"
file = kit.to_file("contract.pdf")

ap file
`open #{file.path}`

