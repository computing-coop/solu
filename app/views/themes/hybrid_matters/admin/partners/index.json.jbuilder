json.array!(@admin_partners) do |admin_partner|
  json.extract! admin_partner, :id
  json.url admin_partner_url(admin_partner, format: :json)
end
