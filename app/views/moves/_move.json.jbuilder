json.extract! move, :id, :created_at, :updated_at, :x_loc, :y_loc
json.url move_url(move, format: :json)
json.selector ".board tr.#{move.y_loc} td.#{move.x_loc}"
