# frozen_string_literal: true

require 'net/http'
require 'nokogiri'
require 'uri'
require_relative 'vacancy_checker'
require_relative 'vacancy_processor'

class HeadHunterParser
  MAX_PAGE_COUNT = 40

  def initialize(title)
    @title = title
    @page = 0
    @vacancies = []
  end

  def parse_hh_vacancies
    MAX_PAGE_COUNT.times do
      html = fetch_html(url)
      doc = Nokogiri::HTML(html)
      vacancy_blocks = doc.css('.vacancy-serp-item__layout')
      process_page(vacancy_blocks)
      @page += 1
    end

    vacancies
  end

  private

  def fetch_html(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    headers = {
      'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
    }
    request = Net::HTTP::Get.new(uri.request_uri, headers)
    response = http.request(request)
    response.body
  end

  def process_page(vacancy_blocks)
    vacancy_blocks.each do |block|
      process_vacancy_block(block)
    end
    puts "page #{@page}"
    puts "count #{vacancies.size}"
  end

  def process_vacancy_block(block)
    vacancy = VacancyProcessor.new(block, title).call

    vacancies << vacancy if VacancyChecker.new(vacancies, vacancy).call
  end

  def encode_title
    URI.encode_www_form_component(title)
  end

  def url
    page_param = @page.positive? ? "&page=#{@page}" : ''
    "https://hh.ru/search/vacancy?text=#{encode_title}#{page_param}"
  end

  attr_reader :title
  attr_accessor :vacancies
end
