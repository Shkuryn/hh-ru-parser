# frozen_string_literal: true

require 'terminal-table'

class Printer

  def print(vacancies)
    strip_columns(vacancies) if vacancies.any?
    table = Terminal::Table.new headings: %w[Link Employer Compensation Title], rows: vacancies
    puts table
    puts "Total = #{vacancies.size}"
  end

  private

  attr_accessor :vacancies

  def strip_columns(vacancies)
    vacancies.each do |vacancy|
      next if vacancy[1].nil? || vacancy[3].nil?

      vacancy[1] = vacancy[1][0, 50]
      vacancy[3] = vacancy[3][0, 50]
    end
  end
end
