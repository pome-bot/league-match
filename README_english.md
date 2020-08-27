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

<p>test account: </p>
<p>　email: red@red</p>
<p>　password: useruser</p>

<br><br>

## Usage

`$ git clone https://github.com/pome-bot/league-match.git`  

<br><br>
 
## Features

<h3 align="center">- Input scores -</h3>

<!-- ![test_gif_2](https://user-images.githubusercontent.com/61574277/89481937-c61bbf80-d7d3-11ea-952f-6f1418bff71f.gif) -->

<p align="center"><a target="_blank" rel="noopener noreferrer" href="https://user-images.githubusercontent.com/61574277/89481937-c61bbf80-d7d3-11ea-952f-6f1418bff71f.gif"><img src="https://user-images.githubusercontent.com/61574277/89481937-c61bbf80-d7d3-11ea-952f-6f1418bff71f.gif" alt="test_gif_2" style="max-width:100%;"></a></p>

---

<h3 align="center">- League table -</h3>

<div align="center">
  <img width="385" alt="32626a0d2cd006e2e820e5f7e1073e3f" src="https://user-images.githubusercontent.com/61574277/89482884-d0d75400-d7d5-11ea-8baf-95d919954b7e.png">
</div>
<br>

---

<h3 align="center">- Recommended order -</h3>

<div align="center">
  <img width="373" alt="9cc21b627b800db2614a47e6b367c5a5" src="https://user-images.githubusercontent.com/61574277/89482914-dcc31600-d7d5-11ea-92ee-480448924a48.png">
</div>
<br>
  
<br><br>
 
## Development environment
### Tools
- Ruby
- Ruby on Rails
- mysql
- Heroku
- Cloud Flare
- Git

### Versions
- Rails version	6.0.3.2
- Ruby version	ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-darwin19]
- RubyGems version	3.0.3
- Rack version	2.2.3


## Database design
## users table (gem: devise)
|Column|Type|Options|
|------|----|-------|
|name|string|null: false, unique: true|
|image|text||
|email|string|null: false, unique: true|
|password|string|null: false|
|deleted_at|datetime||
### Association
- has_many :groups_users
- has_many :groups, through: :groups_users
- has_many :leagues_users
- has_many :leagues, through: :leagues_users
- has_many :games
- has_many :messages

## groups table
|Column|Type|Options|
|------|----|-------|
|name|string|null: false, unique: true|
### Association
- has_many :groups_users
- has_many :users, through: :groups_users, dependent: :destroy
- has_many :leagues, dependent: :destroy

## groups_users table
|Column|Type|Options|
|------|----|-------|
|user_id|integer|null: false, foreign_key: true|
|group_id|integer|null: false, foreign_key: true|
### Association
- belongs_to :group
- belongs_to :user

## leagues table
|Column|Type|Options|
|------|----|-------|
|name|string|null: false, unique: true|
|group_id|integer|null: false, foreign_key: true|
|win_point|integer|null: false, default: 3|
|lose_point|integer|null: false, default: 0|
|even_point|integer|null: false, default: 1|
|order_flag|integer|null: false, default: 0|
### Association
- belongs_to :group
- has_many :leagues_users
- has_many :users, through: :leagues_users, dependent: :destroy
- has_many :games, dependent: :destroy
- has_many :messages, dependent: :destroy

## leagues_users table
|Column|Type|Options|
|------|----|-------|
|user_id|integer|null: false, foreign_key: true|
|league_id|integer|null: false, foreign_key: true|
|order|integer||
|won|integer||
|lost|integer||
|even|integer||
|point|integer||
|difference|integer||
|rank|integer||
### Association
- belongs_to :user
- belongs_to :league

## games table
|Column|Type|Options|
|------|----|-------|
|league_id|integer|null: false, foreign_key: true|
|user_id|integer|null: false, foreign_key: true|
|user_score|integer||
|user2_score|integer||
|order|integer|null: false|
### Association
- belongs_to :user
- belongs_to :league

## messages table
|Column|Type|Options|
|------|----|-------|
|league_id|integer|null: false, foreign_key: true|
|user_id|integer|null: false, foreign_key: true|
|text|string|null: false|
### Association
- belongs_to :league
- belongs_to :user



## License

<p>Copyright (c) 2020 pome-bot</p>
<p>Released under the MIT license</p>

**https://raw.githubusercontent.com/pome-bot/league-match/master/LICENSE.txt**

## Author

[Github](https://github.com/pome-bot)

## Special thanks
<p>Thomas Kirkman</p>
<p>Recommended order function would be impossible without scheduling algorithm. </p>


