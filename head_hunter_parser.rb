# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'uri'
require 'net/http'
require 'openssl'

class HeadHunterParser

  def initialize (title)
    @title = title
  end

  def parse_hh_vacancies
    # url = "https://hh.ru/search/vacancy?text=#{title}"
    url = "https://hh.ru/search/vacancy?text=#{title}&area=113&hhtmFrom=main&hhtmFromLabel=vacancy_search_line"
    headers = {
      "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
    }

    html = URI.open(url, headers).read
    doc = Nokogiri::HTML(html)

    vacancies = []

    vacancy_blocks = doc.css('.vacancy-serp-item__layout')

    vacancy_blocks.each do |block|

      title_elem = block.css('.serp-item__title').first
      vacancy_title = title_elem ? title_elem.text.strip : 'No title found'

      next unless vacancy_title.downcase.include?(title.downcase)

      link_elem = block.css('.bloko-link').first
      link = link_elem ? shorten_url(link_elem['href']) : 'No link found'

      compensation_elem = block.css('.bloko-header-section-2').first
      compensation = compensation_elem ? compensation_elem.text.strip.gsub(/\s+/, ' ') : '???'

      employer_elem = block.css('.vacancy-serp-item__meta-info-company').first
      employer_name = employer_elem ? employer_elem.css('a').first&.text&.strip : 'No employer found'

      vacancy = [vacancy_title, employer_name, compensation, link]

      vacancies << vacancy
    end

    vacancies
  end

  private

  def shorten_url(original_url)
    uri = URI.parse("http://tinyurl.com/api-create.php?url=#{original_url}")
    response = Net::HTTP.get_response(uri)
    response.body.strip
  end

  attr_reader :title
end
