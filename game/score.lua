-- score module
module("score_module", package.seeall)
local score_module = {}

-- constant variables
-- goose multipliers
blue_goose = 100
green_goose = 500
pink_goose = 1000

-- stage multipliers
stage_one = 1
stage_two = 5
stage_two = 10

-- variables
curr_stage = 1
score = 0
kill_count = 0
miss_count = 0


-- raise score
function score(goose_type, time)
    local goose_multiplier = 1
    local stage_multiplier = 1
    local time_multiplier = 1

    -- goose scaling
    if(goose_type == 1) then
      goose_multiplier = blue_goose
    elseif(goose_type == 2) then
      goose_multiplier = green_goose
    elseif(goose_type == 3) then
      goose_multiplier = pink_goose
    end

    -- determine stage
    if(curr_stage == 1) then
      stage_multiplier = stage_one
    elseif(curr_stage == 2) then
      stage_multiplier = stage_two
    elseif(curr_stage == 3) then
      stage_multiplier = stage_two
    end
    -- figure out time scaling
    if(time <= 1) then
      time_multiplier = 5
    elseif(time > 1 and time <= 2 ) then
      time_multiplier = 3
    elseif(time > 2 and time <= 5 ) then
      time_multiplier = 2
    end
    
    score = score + goose_multiplier*stage_multiplier*time_multipler
    kill_count = kill_count + 1

    return score

end

function score_module:get_goose_counter()
    return kill_count
end

function change_round()
    if(curr_stage == 1) then
      curr_stage = 2
      kill_count = 0
    elseif(curr_stage == 2) then
      curr_stage = 3
      kill_count = 0
    end
end

function get_round()
    return curr_stage
end

function score_module:miss_shot()
   miss_count = miss_count + 5
end

function score_module:get_miss_shot()
    return miss_count
end

return score_module