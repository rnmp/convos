json.array!(@comments) do |comment|
  json.extract! comment, :id, :author, :votes, :comment
  json.url comment_url(comment, format: :json)
end
