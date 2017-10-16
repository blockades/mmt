# frozen_string_literal: true

namespace :friendly do
  task :slug do
    sluggable = [ Member, Coin ]
    begin
      sluggable.each { |const| const.find_each(&:save) }
      puts "friendly models slugged!"
    rescue NameError => e
      puts e
    rescue NoMethodError => e
      puts e
    end
  end
end
