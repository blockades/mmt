module MagicMoneyTree
  module InaccessibleWords
    class << self
      def all
        [tables, reserved, blocked].reduce([], :concat).uniq.sort
      end

      def tables
        ActiveRecord::Base.connection.tables
      end

      def reserved
        @reserved ||= YAML.load_file('config/reserved_words.yml').compact
      end

      def blocked
        @blocked ||= YAML.load_file('config/blocked_words.yml').compact
      end
    end
  end

  module MobileCountryCodes
    class << self
      def all
        @all ||= YAML.load_file('config/mobile_codes.yml').compact
      end

      def for_select
        @for_select ||= all.inject([]) do |collection, line|
          collection << ["#{line[:country]} (+#{line[:code]})", "+#{line[:code]}"]
        end
      end
    end
  end
end
