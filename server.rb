require 'csv'
require 'pry'
require 'sinatra'
require 'sinatra/reloader'

def load_game_data
  game_data = []

  CSV.foreach('Workbook1.csv', headers:true, header_converters: :symbol, converters: :numeric) do |row|
    game_data << row.to_hash
  end

  game_data
end

###############################
#       Find Winners
###############################

def win_records(game_data)
  winners = []

  game_data.each do |game|
    if game[:home_score] > game[:away_score]
      winners << game[:home_team]
    elsif game[:away_score] > game[:home_score]
      winners << game[:away_team]
    end
  end

  win_record = Hash.new(0)

  winners.each do |team|
    win_record[team] += 1
  end

  win_record
end

###############################
#      Find losers
###############################

def loss_records(game_data)
  losers = []

  game_data.each do |game|
    if game[:home_score] < game[:away_score]
      losers << game[:home_team]
    elsif game[:away_score] < game[:home_score]
      losers << game[:away_team]
    end
  end

  loss_record = Hash.new(0)

  losers.each do |team|
    loss_record[team] += 1
  end

  loss_record
end

###############################
#       METHODS
###############################

def team_list(game_data)
  teams = []

  game_data.each do |game|
    teams << game[:home_team]
    teams << game[:away_team]
  end

  teams.uniq!
end

#DON'T KNOW WHY THE METHOD BELOW WON'T WORK

# def opponents(team, data)
# opponents = Hash.new
# oppo = []

#   data.each do |row|
#     while row[:home_team] == team
#       oppo << row[:away_team]
#       opponents[team] = oppo

#       if team == row[:away_team]
#         oppo << row[:home_team]
#         opponents[team] = oppo
#       end
#     end
#   end
#   opponents
#   binding.pry
# end

# puts opponents(team_info, team_info)

###############################
#       GET BLOCS
###############################
get '/leaderboard' do
  game_data = load_game_data

  @teams = team_list(game_data)
  @win_record = win_records(game_data)
  @loss_record = loss_records(game_data)
  erb :leaderboard
end



