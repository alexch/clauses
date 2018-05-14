#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'awesome_print'

def usage
  $stderr.puts "Usage: process.rb file"
  exit 1
end

source = ARGV[0] || usage

source = Pathname.new(source)
output_path = File.join(source.dirname,
  source.basename.to_s.split('.')[0..-2].join('.') +
  '-' + Date.today.iso8601 +
  '.pdf')

body = source.is_a?(IO) ? source.read : File.read(source)

def false? x
  ["false", "0", "no"].include?(x.downcase)
end

# parse headers
if body.each_line.first =~ /^\s+\w+:/
  headers, body = body.split("\n\n", 2)
  scope = Hash[headers.each_line.map do |line|
                 line.split(':', 2).map { |x| x.strip }.
                  map { |x|  false?(x) ? false : x }
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
kit = PDFKit.new(html,
  :page_size => 'Letter',
  :print_media_type => true,
  :dpi => 400)
kit.stylesheets << "contract-style.css"
file = kit.to_file(output_path)

ap file
`open #{file.path}`
