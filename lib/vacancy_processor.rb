# frozen_string_literal: true

class VacancyProcessor

  def initialize(block, title)
    @block = block
    @title = title
  end

  def call
    title_elem = block.css('.serp-item__title').first
    vacancy_title = title_elem ? title_elem.text.strip : 'No title found'

    return nil unless vacancy_title.downcase.include?(title.downcase)

    link_elem = block.css('.bloko-link').first
    link = link_elem ? shorten_url(link_elem['href']) : 'No link found'

    compensation_elem = block.css('.bloko-header-section-2').first
    compensation = compensation_elem ? compensation_elem.text.strip.gsub(/\s+/, ' ') : '???'

    employer_elem = block.css('.vacancy-serp-item__meta-info-company').first
    employer_name = employer_elem ? employer_elem.css('a').first&.text&.strip : 'No employer found'

    [vacancy_title, employer_name, compensation, link]
  end

  private

  attr_reader :block, :title

  def shorten_url(original_url)
    uri = URI.parse("http://tinyurl.com/api-create.php?url=#{original_url}")
    response = Net::HTTP.get_response(uri)
    response.body.strip
  end

end
