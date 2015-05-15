json.array!(@devotionals) do |devotional|
  json.extract! devotional, :id, :title, :day, :passage, :passage_text, :story, :questions, :passage_mem, :quote
  json.url devotional_url(devotional, format: :json)
end
