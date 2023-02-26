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
bullet_count = 3


-- raise score
function score_module:update_score()
    local stage_multiplier = 1

    -- determine stage
    if(curr_stage == 1) then
      stage_multiplier = stage_one
    elseif(curr_stage == 2) then
      stage_multiplier = stage_two
    elseif(curr_stage == 3) then
      stage_multiplier = stage_two
    end
    
    score = score + stage_multiplier
    kill_count = kill_count + 1

    return score

end

function score_module:get_score()
    return score
end

function score_module:get_goose_counter()
    return kill_count
end

function score_module:lose_bullet()
    bullet_count = bullet_count - 1
end

function score_module:reload()
    bullet_count = bullet_count + 1
end

function score_module:get_bullets()
    return bullet_count
end

function score_module:change_round()
    if(curr_stage == 1) then
      curr_stage = 2
      kill_count = 0
    elseif(curr_stage == 2) then
      curr_stage = 3
      kill_count = 0
    end
end

function score_module:get_round()
    return curr_stage
end

function score_module:miss_shot()
   miss_count = miss_count + 5
end

function score_module:get_miss_shot()
    return miss_count
end

return score_module