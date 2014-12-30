json.array!(@products) do |product|
  json.extract! product, :id, :tag, :tag1, :tag2, :tag3, :tag4, :tag5, :tag6, :tag7, :tag8, :tag9
  json.url product_url(product, format: :json)
end
