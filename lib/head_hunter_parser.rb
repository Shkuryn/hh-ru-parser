# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'uri'
require 'net/http'
require 'openssl'
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
      url = "https://hh.ru/search/vacancy?text=#{encode_title}&page=#{@page}"
      headers = {
        'User-Agent' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
      }

      html = URI.open(url, headers).read
      doc = Nokogiri::HTML(html)

      vacancy_blocks = doc.css('.vacancy-serp-item__layout')

      process_page(vacancy_blocks)
      @page += 1
    end

    vacancies
  end

  private

  def process_page(vacancy_blocks)
    vacancy_blocks.each do |block|
      process_vacancy_block(block)
    end
  end

  def process_vacancy_block(block)
    vacancy = VacancyProcessor.new(block,title).call

    vacancies << vacancy if VacancyChecker.new(vacancies, vacancy).call
  end

  def encode_title
    URI.encode_www_form_component(title)
  end

  attr_reader :title
  attr_accessor :vacancies
end
