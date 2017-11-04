require "json"

class Glabtodoscr::Todo
  JSON.mapping(
    id: Int32,
    target_type: String,
    body: String,
    state: String,
    target_url: String,
    action_name: String,
  )
end
