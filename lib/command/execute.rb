# frozen_string_literal: true

module Command
  class Execute

    def execute(command)
      command.validate!
      handler_for(command).call(command)
    end

    private

    def handler_for(command)
      if command.respond_to?(:handler_class)
        command.handler_class.new
      else
        handler_class_name = command.class.name.gsub('Command','Handlers')
        handler_class_name.constantize.new
      end
    end

  end
end
