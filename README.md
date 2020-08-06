# README

<h2 align="center">League Match App</h2>

<div align="center">
  <img width="369" alt="f3be127c9775160480fba7540aa72e31" src="https://user-images.githubusercontent.com/61574277/89480753-1e04f700-d7d1-11ea-82cd-93f4ca9b96dd.png">
</div>

<br><br><br>

## What is this?
<p>
You can manage league match (round robin tournament) results. A group can be created, and leagues can be created in each groups. This app features are as follows.
</p>

- Leagues can be created in a group.
- Game results can be registered.
- Game order are automatically created.
- Comments can be posted in each leagues.
- Total results of a user can be seen.

<br><br>

## App URL

### **https://peaceful-brushlands.ml**  

<br><br>

## Usage

`$ git clone https://github.com/pome-bot/league-match.git`  

<br><br>
 
## Features

<h3 align="center">- Input scores -</h3>

![test_gif_2](https://user-images.githubusercontent.com/61574277/89481937-c61bbf80-d7d3-11ea-952f-6f1418bff71f.gif)

---

<h3 align="center">- League table -</h3>

<img width="385" alt="32626a0d2cd006e2e820e5f7e1073e3f" src="https://user-images.githubusercontent.com/61574277/89482884-d0d75400-d7d5-11ea-8baf-95d919954b7e.png">

- リーグが作成されるとリーグ表が作成される。
- スコアが送信されると、そのスコアが反映される。
- デフォルトでは、以下の設定となっている。
  - はじめは並びは名前順
  - スコアがあると、並びはランク順
  - 勝ち点は、勝ち：3、負け：0、引き分け：1
- ランクは以下のとおりにつけられる。
  - 勝ち点の高いほうが上
  - 勝ち点が同じ場合は、得失点差の高いほうが上
  - 勝ち点、得失点差が同じで、それが2名だった場合、その2名の対戦の勝者が上
  - 勝ち点、得失点差が同じで、それが2名だった場合で、その2名の対戦が引き分けのときは同ランク
  - 勝ち点、得失点差が同じで、それが3名以上だった場合、同ランク
- リーグの設定で以下のことが可能
  - 勝ち点の設定
  - 並び順の設定（名前順、ランク順）
- スコアが表示される箇所をクリックすると、スコアフォームにデータが入る。
- スコアの訂正は何度でも可能
- スコアをリセットしたい場合は、対戦者のみを送信することでリセットできる。

---

<h3 align="center">- Recommended order -</h3>

<img width="373" alt="9cc21b627b800db2614a47e6b367c5a5" src="https://user-images.githubusercontent.com/61574277/89482914-dcc31600-d7d5-11ea-92ee-480448924a48.png">

- リーグが作成されるとおすすめの試合順が作成される。
- このおすすめの試合順の特徴は以下のとおり。
  - メンバーそれぞれ1試合ある組み合わせを1ラウンドとしている。
  - ラウンド毎に試合相手が変わる。
  - 最後までラウンドを行うと、全試合できることとなる。
  - メンバーの数が偶数のときラウンド数：（メンバーの数 - 1）、奇数のときラウンド数：メンバーの数 
  - メンバーの数が奇数のとき、それぞれのラウンドで試合の無いメンバーが1人いる。
  - 試合間隔は可能な限り公平となるようになっている。
  - 左側を先攻、右側を後攻と決めることで、バランスよく試合することができる。
  - それぞれの試合の箇所をクリックすると、スコアフォームにデータが入る。
  - リーグ作成ごとに作成される試合順はランダムである。
  
<br><br>

## License

Copyright (c) 2020 pome-bot
Released under the MIT license
**https://github.com/pome-bot/league-match/blob/master/LICENSE.txt**

 
## Versions

- Rails version	6.0.3.2
- Ruby version	ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-darwin19]
- RubyGems version	3.0.3
- Rack version	2.2.3


## Author

[Github](https://github.com/pome-bot)
 

## Special thanks

Thomas Kirkman
Recommended order won't be possible without scheduling algorithm. 


