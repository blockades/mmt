Rails.application.config.event_store.tap do |event_store|
  event_store.subscribe(Denormalizers::AssetAddedToPortfolio, [Events::AssetAddedToPortfolio])
  event_store.subscribe(Denormalizers::AssetRemovedFromPortfolio, [Events::AssetRemovedFromPortfolio])
  event_store.subscribe(Denormalizers::AssetValueChanged, [Events::ChangeAssetValue])
  event_store.subscribe(Denormalizers::PortfolioFinalised, [Events::PortfolioFinalised])
end
