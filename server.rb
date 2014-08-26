require 'csv'
require 'pry'
require 'sinatra'
require 'sinatra/reloader'

team_info = []
CSV.foreach('Workbook1.csv', headers:true, header_converters: :symbol, converters: :numeric) do |row|
  team_info << row.to_hash
end

###############################
#       Find Winners
###############################

winners = []

team_info.each do |row|
  if row[:home_score] > row[:away_score]
    winners << row[:home_team]
  elsif row[:away_score] > row[:home_score]
    winners << row[:away_team]
  end
end

win_record = Hash.new(0)

winners.each do |team|
  win_record[team] += 1
end

###############################
#      Find losers
###############################

losers = []

team_info.each do |row|
  if row[:home_score] < row[:away_score]
    losers << row[:home_team]
  elsif row[:away_score] < row[:home_score]
    losers << row[:away_team]
  end
end

loss_record = Hash.new(0)

losers.each do |team|
  loss_record[team] += 1
end

###############################
#       METHODS
###############################

def team_list(game_data)
  teams = []

  game_data.each do |row|
    teams << row[:home_team]
    teams << row[:away_team]
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
  @teams = team_list(team_info)
  @win_record = win_record
  @loss_record = loss_record
  erb :leaderboard
end



