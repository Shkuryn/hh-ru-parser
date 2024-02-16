# frozen_string_literal: true

require './lib/head_hunter_parser'
require 'terminal-table'

if __FILE__ == $PROGRAM_NAME
  title = if ARGV.count < 1
            'ruby'
          else
            ARGV.join(' ')
          end

  vacancies = HeadHunterParser.new(title).parse_hh_vacancies
  table = Terminal::Table.new headings: ['Title', 'Employer', 'Compensation', "link",], rows: vacancies
  puts table
  puts vacancies.size
end
