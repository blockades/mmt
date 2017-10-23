Rails.application.config.event_store.tap do |event_store|
  event_store.subscribe(Workers::AssetAddedToPortfolio, [Events::AssetAddedToPortfolio])
  event_store.subscribe(Workers::AssetRemovedFromPortfolio, [Events::AssetRemovedFromPortfolio])
  event_store.subscribe(Workers::PortfolioFinalised, [Events::PortfolioFinalised])
end
