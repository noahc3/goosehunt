-- score module


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
kill_count = 0;

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

  -- determine stage
  if(curr_stage == 1) then
    stage_multiplier = stage_one
  elseif(curr_stage == 2) then
    stage_multiplier = stage_two
  elseif(curr_stage == 3) then
    stage_multiplier = stage_two

  -- figure out time scaling
  if(time <= 1) then
    time_multiplier = 5
  elseif(time > 1 && time <= 2 ) then
    time_multiplier = 3
  elseif(time > 2 && time <= 5 ) then
    time_multiplier = 2
  
  score = score + goose_multiplier*stage_multiplier*time_multipler
  kill_count = kill_count + 1

  return score

end


function change_round()
  if(kill_count == 10) then
    curr_stage = 2
  elseif(kill_count == 20) then
    curr_stage = 3
  elseif(kill_count == 30) then
    -- end game

end

