# encoding: UTF-8
require_relative "wizcsv/version"

module Wizcsv
  class Csv
    attr_reader :header, :row_count

    def initialize(options = {})
      default = { file_path: nil,
                  col_sep: ",",
                  row_sep: "\n",
                  quote_char: '"',
                  comment: "#",
                  chunk_size: 500,
                  file_encoding: 'UTF-8' }
      @options = default.merge(options)
      raise ArgumentError, "file_path is required" unless @options[:file_path]
      raise ArgumentError, "chunk_size must be positive" unless @options[:chunk_size] > 0
      @field = nil
      @row = []
      @rows = []
      @row_count = 0
      @header = []
      @quote_open = false
      begin
        @io = File.open(@options[:file_path], encoding: @options[:file_encoding])
      rescue Errno::ENOENT
        raise ArgumentError, "file_path does not exist"
      rescue Errno::EACCES
        raise ArgumentError, "file_path cannot be opened"
      end
      #@lookahead = ""
    end

    def peek_next_char
      pos = @io.pos
      char = @io.getc
      @io.pos = pos
      char
    end

    def add_row(field)
      #field.gsub!('""', '"')
      @row << field
      @field = nil
    end

    def add_field(char)
      @field ||= ""
      @field << char
    end

    def add_rows
      @row_count += 1
      if @header.empty?
        @header = @row
      else
        @rows << @row
      end
      @row = []
    end

    def parse(&block)
      @io.each_char do |c|
        case c
        when @options[:quote_char]
          if @quote_open
            if peek_next_char == @options[:quote_char]
              add_field(c)
              @io.getc
            else
              @quote_open = false
            end
          else
            if @field.nil?
              @quote_open = true
            else
              add_field(c)
            end
          end

        when @options[:col_sep]
          if @quote_open
            add_field(c)
          else
            add_row(@field)
          end

        when @options[:row_sep]
          if @quote_open || (!@quote_open && !@header.empty? && @row.size != @header.size - 1)
            add_field(c)
          else
            add_row(@field)
            add_rows
          end

          while peek_next_char == @options[:row_sep]
            @io.getc
          end

          # when "\\"
          #   # @field << c
          #   # p @field
        else
          add_field(c)
        end

        if @io.eof? && !@row.empty?
          add_row(@field)
          add_rows
        end

        if block_given? && (@rows.size == @options[:chunk_size] || @io.eof?)
          block.call(@rows, self)
          @rows = []
        end
      end
      p @row_count
      @io.close
    end
  end

  def self.parse(options, &block)
    csv = Csv.new(options)
    csv.parse(&block)
  end
end

if __FILE__ == $0
  Wizcsv.parse({ file_path: "E:\\ac_2.csv" }) do |rows|
    rows.each do |row|
      p row
    end
  end
end
