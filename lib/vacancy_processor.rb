# frozen_string_literal: true

class VacancyProcessor

  def initialize(block, title)
    @block = block
    @title = title
  end

  def call
    return nil unless relevant_vacancy?

    [link, employer_name, compensation, vacancy_title]
  end

  private

  attr_reader :block, :title

  def relevant_vacancy?
    vacancy_title.downcase.include?(title.downcase)
  end

  def vacancy_title
    title_elem = block.css('.serp-item__title').first
    title_elem ? title_elem.text.strip : 'No title found'
  end

  def link
    link_elem = block.css('.bloko-link').first
    link_elem ? shorten_url(link_elem['href']) : 'No link found'
  end

  def compensation
    compensation_elem = block.css('.bloko-header-section-2').first
    compensation_elem ? compensation_elem.text.strip.gsub(/\s+/, ' ') : '???'
  end

  def employer_name
    employer_elem = block.css('.vacancy-serp-item__meta-info-company').first
    employer_elem ? employer_elem.css('a').first&.text&.strip : 'No employer found'
  end

  def shorten_url(original_url)
    uri = URI.parse("http://tinyurl.com/api-create.php?url=#{original_url}")
    response = Net::HTTP.get_response(uri)
    response.body.strip
  end

end
