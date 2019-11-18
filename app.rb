require 'sinatra'
require 'sinatra/reloader'
require "base64" # For Base64Image
require 'mechanize' # For scraping
require 'csv'

get '/' do
  erb :form
end

post '/scraping' do
  urls       = params[:form_urls].split("\r\n")
  elements   = params[:form_elements].split("\r\n")
  csv_header = 'URL,Search Element(検索要素/XPath),Result(スクレイピング結果)' + "\n"
  agent      = Mechanize.new
  sleep_time = 30

  @csv = CSV.generate(csv_header, headers: true) do |csv|
    urls.each do |url|
      elements.each do |element|
        begin
          page = agent.get(url) # Get page via Mechanize
          scraped_value = page.search(element).inner_text.strip
          csv.add_row([url, element, scraped_value])
        rescue
          # Something like "Mechanize::ResponseCodeError" error
          scraped_value = 'ERROR!'
          csv.add_row([url, element, scraped_value])
        end

        sleep(sleep_time)
      end
    end
  end

  erb :scraping
end

__END__

@@ layout
<!DOCTYPE html>
<html lang="ja">
  <head>
    <title>簡易スクレイピングツール「るるる」</title>

    <!-- Materialize -->
      <!-- Compiled and minified CSS -->
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
      <!--Import Google Icon Font -->
      <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
      <!-- Compiled and minified JavaScript -->
      <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
    <!-- /Materialize -->

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css?family=M+PLUS+1p:300&display=swap" rel="stylesheet">

    <style type="text/css">
      <!--
      body { font-family: 'M PLUS 1p', sans-serif; } /* Google Fonts */
      -->
    </style>

  </head>
  <body>
    <nav class="blue-grey lighten-1">
      <div class="container">
        <div class="nav-wrapper">
          <a href="/" class="brand-logo">るるる</a>
        </div>
      </nav>
    </div>

    <%= yield %>

    <footer class="page-footer blue-grey lighten-1">
      <div class="container ">
        <div class="row">
          <div class="col s12">
            <h5 class="white-text">簡易スクレイピングツール「るるる」</h5>
            <p class="grey-text text-lighten-4">指定したURLのページから文字列の取得（スクレイピング）をすることができます</p>
          </div>
        </div>
      </div>
      <div class="footer-copyright">
        <div class="container">
        by 256hax
        <a class="grey-text text-lighten-4 right" target="_blank" href="https://github.com/256hax/rururu"><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyRpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDIxIDc5LjE1NDkxMSwgMjAxMy8xMC8yOS0xMTo0NzoxNiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6RERCMUIwOUY4NkNFMTFFM0FBNTJFRTMzNTJEMUJDNDYiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6RERCMUIwOUU4NkNFMTFFM0FBNTJFRTMzNTJEMUJDNDYiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoTWFjaW50b3NoKSI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOkU1MTc4QTJBOTlBMDExRTI5QTE1QkMxMDQ2QTg5MDREIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOkU1MTc4QTJCOTlBMDExRTI5QTE1QkMxMDQ2QTg5MDREIi8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8+jUqS1wAAApVJREFUeNq0l89rE1EQx3e3gVJoSPzZeNEWPKgHoa0HBak0iHiy/4C3WvDmoZ56qJ7txVsPQu8qlqqHIhRKJZceesmhioQEfxTEtsoSpdJg1u/ABJ7Pmc1m8zLwgWTmzcw3L+/te+tHUeQltONgCkyCi2AEDHLsJ6iBMlgHL8FeoqokoA2j4CloRMmtwTmj7erHBXPgCWhG6a3JNXKdCiDl1cidVbXZkJoXQRi5t5BrxwoY71FzU8S4JuAIqFkJ2+BFSlEh525b/hr3+k/AklDkNsf6wTT4yv46KIMNpsy+iMdMc47HNWxbsgVcUn7FmLAzzoFAWDsBx+wVP6bUpp5ewI+DOeUx0Wd9D8F70BTGNjkWtqnhmT1JQAHcUgZd8Lo3rQb1LAT8eJVUfgGvHQigGp+V2Z0iAUUl8QH47kAA1XioxIo+bRN8OG8F/oBjwv+Z1nJgX5jpdzQDw0LCjsPmrcW7I/iHScCAEDj03FtD8A0EyuChHgg4KTlJQF3wZ7WELppnBX+dBFSVpJsOBWi1qiRgSwnOgoyD5hmuJdkWCVhTgnTvW3AgYIFrSbZGh0UW/Io5Vp+DQoK7o80pztWMemZbgxeNwCNwDbw1fIfgGZjhU6xPaJgBV8BdsMw5cbZoHsenwYFxkZzl83xTSKTiviCAfCsJLysH3POfC8m8NegyGAGfLP/VmGmfSChgXroR0RSWjEFv2J/nG84cuKFMf4sTCZqXuJd4KaXFVjEG3+tw4eXbNK/YC9oXXs3O8NY8y99L4BXY5cvLY/Bb2VZ58EOJVcB18DHJq9lRsKr8inyKGVjlmh29mtHs3AHfuhCwy1vXT/Nu2GKQt+UHsGdctyX6eQyNvc+5sfX9Dl7Pe2J/BRgAl2CpwmrsHR0AAAAASUVORK5CYII="></a>
        </div>
      </div>
    </footer>
  </body>
</html>

@@ form
<div class="container">
  <h4>Scraping Settings</h4>

  <form id="scraping_input" method="post" action="/scraping">
    <div class="input-field">
      <div class="row">
        <div class="input-field col s12">
          <textarea name="form_urls" class="materialize-textarea"></textarea>
          <label for="textarea1">URLs</label>
          <span class="helper-text" data-error="wrong" data-success="right">複数のURLを指定する場合は改行区切り</span>
        </div>
      </div>

      <div class="row">
        <div class="input-field col s12">
          <textarea name="form_elements" class="materialize-textarea"></textarea>
          <label for="textarea2">Elements/XPath</label>
          <span class="helper-text" data-error="wrong" data-success="right">複数の検索要素またはXPathを指定する場合は改行区切り</span>
        </div>
      </div>

      <div>
        <button form="scraping_input" name="button" type="submit" class="btn waves-effect waves-light light-blue lighten-1">Scraping</button>
      </div>
      <div class="section">
        <ul>
          <li>・ページが見つからない（404 Not Foundなど）場合は、取得結果に「ERROR!」と出力されます。</li>
          <li>・Check policy, robots.txt and legal before scraping. スクレイピング前に対象サイトの利用規約やrobots.txt、違法性がないか（「スクレイピング 違法」などで検索）などのチェックをおすすめします。</li>
          <li>・攻撃とみなされないように１スクレイピング毎にスリープ時間を入れています。目安として１URL毎に４０秒ほどかかります。</li>
        </ul>
      </div>
    </div>
  </form>
</div>

@@ scraping
<div class="container">
  <h4>Result CSV</h4>
  <div class="input-field">
    <div class="row">
      <div class="input-field col s12">
        <textarea name="form_elements" class="materialize-textarea"><%= @csv %></textarea>
        <span class="helper-text" data-error="wrong" data-success="right">CSV形式で結果が出力されます</span>
      </div>
    </div>
    <a class="btn blue-grey lighten-1" href="/">← Back</a>
    </div>
  </div>
