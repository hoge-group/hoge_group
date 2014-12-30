json.array!(@seminars) do |seminar|
  json.extract! seminar, :id, :summary
  json.url seminar_url(seminar, format: :json)
end
