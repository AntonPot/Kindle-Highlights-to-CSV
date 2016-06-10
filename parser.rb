require 'kindle_highlights'
require 'csv'

module Parser

  class Kindle
    attr_reader :books, :data
    def initialize(email, password)
      @data = KindleHighlights::Client.new(email_address: email, password: password)
      @books = @data.books
    end

    class Highlight
      attr_accessor :data
      def initialize(data)
        @data = data
      end
      def add_title(title)
        @data.merge('title' => title)
      end
    end

    def full_book_info(id, title)
      @data.highlights_for(id).map do |highlight|
        Highlight.new(highlight).add_title(title)
      end
    end

    def books_highlights
      joint_array = Array.new
      @books.each {|id_title| joint_array += full_book_info( id_title[0], id_title[1])}
      joint_array
    end
  end

  class CsvGenerator
    def self.go(data, filename)
      CSV.open(filename, "wb") do |csv|
        csv << data.first.keys
        data.each do |hash|
          csv << hash.values
        end
      end
    end
  end
end
