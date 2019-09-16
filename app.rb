require 'sinatra'
require 'sinatra/reloader'
#require "base64" # Uncomment if use imase
require 'mechanize' # Scraping
require 'csv'

get "/" do
  agent = Mechanize.new

  urls = []
  urls[0] = 'https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC'
  urls[1] = 'https://ja.wikipedia.org/wiki/%E3%82%BF%E3%82%A4%E7%8E%8B%E5%9B%BD'

  elements = []
  elements[0] = '//*[@id="infoboxCountry"]/dd[5]/table/tbody/tr[2]/td/a'
  elements[1] = '//*[@id="infoboxCountry"]/dd[5]/table/tbody/tr[4]/td/dl/dd[3]/table/tbody/tr[1]/td/a[1]'

  csv_header = 'URL,Search Element(検索要素/XPath),Result(スクレイピング結果)' + "\n"

  @csv = CSV.generate(csv_header, headers: true) do |csv|
    urls.each do |url|
      elements.each do |element|
        page = agent.get(url)
        scraped_value = page.search(element).inner_text.strip
        csv.add_row([url, element, scraped_value])
        sleep(20)
      end
    end
  end

  erb :index
end

__END__

@@ layout
<!DOCTYPE html>
<html lang="ja">
  <head>
    <title>簡易スクレイピングツール「るるる」</title>
  </head>

  <body>
    <%= yield %>
  </body>
</html>

@@ index
aaa
<%= @csv %>
