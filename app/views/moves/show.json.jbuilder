json.set! :move do
    json.partial! "moves/move", move: @move if @move.present?
end

json.set! :cpu_move do
    json.partial! "moves/move", move: @cpu_move if @cpu_move.present?
end
