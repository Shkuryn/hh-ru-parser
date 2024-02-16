# frozen_string_literal: true

class VacancyChecker
  def initialize(vacancies, vacancy)
    @vacancies = vacancies
    @vacancy = vacancy
  end

  def call
    return false if vacancy.nil?

    vacancies.find { |v| v[1] == vacancy[1] }.nil? ? true : false
  end

  private

  attr_reader :vacancies, :vacancy

end
