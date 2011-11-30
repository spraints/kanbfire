KanbfireConfig = StaticConfig.build do
  file Rails.root.join('config/kanbfire.yml'), :section => Rails.env
end
