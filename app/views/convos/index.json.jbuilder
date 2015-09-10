json.array!(@convos) do |convo|
  json.extract! convo, :id, :title, :author, :votes, :url, :comment
  json.url convo_url(convo, format: :json)
end
