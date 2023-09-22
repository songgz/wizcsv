Wizcsv is a simple and efficient csv parser implemented in ruby, with certain fault tolerance.

# Instructions for use:

Install and import Wizcsv: gem install wizcsv

require 'wizcsv'

# how to use:

options are the following options:

file_path: Path to the CSV file (required).

col_sep: column separator, default is comma.

row_sep: row separator, default is newline character.

quote_char: quote character, default is double quote.

comment: comment character, default is pound sign.

chunk_size: Chunk size, default is 500.

file_encoding: File encoding, the default is UTF-8.

Wizcsv.parse(options) do |rows, csv| 

p rows 

end 

In the block you can process the data for each row. The rows parameter is an array of rows containing parsed row data. The csv parameter is an instance object.
