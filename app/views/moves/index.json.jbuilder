json.array! @moves[:cpu_move], partial: 'moves/move', as: :move
json.array! @moves[:move], partial: 'moves/cpu_move', as: :move
