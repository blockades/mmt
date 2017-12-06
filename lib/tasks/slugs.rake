# frozen_string_literal: true

namespace :friendly do
  task :slug do
    sluggable = [Member, Coin]
    begin
      sluggable.each { |const| const.find_each(&:save) }
      puts "friendly models slugged!"
    end
  end
end
