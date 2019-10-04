My Pet Project. rururu (るるる) is a simple scraping tool.
「るるる」はシンプルなスクレイピングツールです。

## Features
- Get values with URLs and Elements. URLと検索要素（XPathなど）を指定して文字列を抽出
- CSV output. 抽出結果はCSV形式で出力
- Sleep per one scraping for prevent being consider an attack. スクレイピング中に攻撃とみなされないように１スクレイピング毎にスリープ時間を定義

## Technologies
### Frontend Layer
- [Materialize](https://materializecss.com/)
- [Google Fonts](https://fonts.google.com/)

### Application Layer
- [Ruby](https://www.ruby-lang.org/en/) 💎
- [Sinatra](http://sinatrarb.com/) 🎩
- RubyGem [Mechanize](https://github.com/sparklemotion/mechanize)

### Development
- App file is only One-File also including images on Sinatra. Sinatraを使って１ファイルのみで開発

## Install
1. Install Ruby
2. Download & Unarchive rururu(るるる) zip in GitHub
3. $ cd rururu
4. $ gem install bundler:2.0.1
5. $ gem update bundler
6. $ bundle install --path vendor/bundle
7. $ bundle exec ruby app.rb
8. Open http://localhost:4567/ in some browser

## HowTo Use
### 1.Form
#### 1行1URLで入力
例：Wikipediaの日本とタイ王国のページをスクレイピングする場合
```
https://ja.wikipedia.org/wiki/%E6%97%A5%E6%9C%AC
https://ja.wikipedia.org/wiki/%E3%82%BF%E3%82%A4%E7%8E%8B%E5%9B%BD
```

![Scraping Form](https://raw.githubusercontent.com/256hax/rururu/master/docs/screenshot/scraping-form.png)

#### 1行1要素/XPathで入力
例：首都と人口をXPathで取得する場合
```
//*[@id="infoboxCountry"]/dd[5]/table/tbody/tr[2]/td/a
//*[@id="infoboxCountry"]/dd[5]/table/tbody/tr[4]/td/dl/dd[3]/table/tbody/tr[1]/td/a[1]
```

![Result CSV](https://raw.githubusercontent.com/256hax/rururu/master/docs/screenshot/result-csv.png)

### 2.Result
1. Copy & Paste result(textarea) values to textpad. スクレイピング結果をメモ帳などにコピペ
2. Save as somename.csv. 適当な名前をつけてCSV形式で保存
