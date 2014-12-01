require 'spec_helper'

describe OpenGraphy, :vcr do
  subject { OpenGraphy.fetch(url) }

  let(:url) { 'http://www.imdb.com/title/tt2084970/?ref_=inth_ov_tt' }

  describe '.fetch' do
    it 'should return an object with the opengraph data' do
      expect(subject).to be_kind_of(OpenGraphy::MetaTags)
    end
  end

  describe 'custom metatags' do
    let(:url) { 'https://www.onthebeach.co.uk/deals/53ee67c676036401a67eab73026a97f9/e01a07efddb6e124da373b31222c162f/80507aab0fb81591a992fcc5b77d93a4' }
    before do
      OpenGraphy.configure do |config|
        config.metatags = ["og:", "onthebeach:deal:", "onthebeach:hotel:"]
      end
    end

    let(:expected_keys) {
      [
        "title", "description","image","type", "url", "site_name",
        "id", "hotel_id", "board_code", "price", "hotel_result_id",
        "board_result_id", "flight_result_id", '__html_title_tag'
      ]
    }

    it 'returns OnTheBeach meta tags' do
      expect( subject.title ).to eq(expected_keys)
    end
  end

  describe 'try to fetch from a website that does not exist' do
    let(:open_graphy_data) { OpenGraphy.fetch('http://google.com/404.html') }

    it "return data class with url" do
      expect(open_graphy_data.url).to eql('http://google.com/404.html')
    end
  end
end
