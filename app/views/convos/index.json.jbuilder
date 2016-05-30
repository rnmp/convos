json.array!(@convos) do |convo|
  json.extract! convo, :id, :convo
end
