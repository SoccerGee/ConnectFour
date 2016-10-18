json.set! :move do
  json.partial! "moves/move", move: @move
end

json.set! :cpu_move do
  json.partial! "moves/move", move: @cpu_move
end
