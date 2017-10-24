# frozen_string_literal: true

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
end
