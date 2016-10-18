json.extract! move, :x_loc, :y_loc
json.selector ".board tr.#{move.y_loc} td.#{move.x_loc}"
json.cpu true
