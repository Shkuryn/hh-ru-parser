# frozen_string_literal: true

class Printer
  def initialize(vacancies)
    @vacancies = vacancies
  end

  def print
    strip_columns
    table = Terminal::Table.new headings: ['Link', 'Employer', 'Compensation', 'Title'], rows: vacancies
    puts table
    puts "Total = #{vacancies.size}"
  end

  private

  attr_accessor :vacancies

  def strip_columns
    vacancies.each do |vacancy|
      vacancy[1] = vacancy[1][0, 50]
      vacancy[3] = vacancy[3][0, 50]
    end
  end

end
