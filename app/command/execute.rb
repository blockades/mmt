module Command
  module Execute
    def execute(command)
      command.validate!
      handler_for(command).call(command)
    end

    private

    def handler_for(command)
      {
        Command::AddAssetToPorfolio => CommandHandler::AddAssetToPortfolio.new,
        Command::UpdateAssetValue => CommandHandler::UpdateAssetValue.new,
        Command::FinalisePortfolio => CommandHandler::FinalisePortfolio.new
      }.fetch(command.class)
    end

  end
end
