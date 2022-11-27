require 'cairo'

white = '${color white}'
green = '${color #4EB562}'
yellow = '${color #D4AC0D}'
orange = '${color #D35400}'
red = '${color #B03A2E}'

function conky_lpad(n, s)
    format = '%' .. n .. 's'
    return string.format(format , conky_parse(s))
end

function conky_rpad(n, s)
    format = '%-' .. n .. 's'
    return string.format(format , conky_parse(s))
end

function conky_color_battery(s)
  cmd = '${battery_bar 10}'

  status = conky_parse(s)
  discharging = string.match(status, 'discharging')
  if discharging == nil then
    return green .. cmd
  end

  percent_str = string.match(status, '[0-9]+')
  percent = tonumber(percent_str)

  color = white
  if percent > 80 then
    color = green
  elseif percent > 50 then
    color = yellow
  elseif percent > 20 then
    color = orange
  else
    color = red
  end
  return color .. cmd
end

function conky_color_cpu(n)
  numCmd = '${cpu cpu' .. n .. '}'
  barCmd = '${cpubar cpu' .. n .. ' 10}'

  percent_str = string.match(conky_parse(numCmd), '[0-9]+')
  percent = tonumber(percent_str)

  if percent > 75 then
    color = red
  elseif percent > 50 then
    color = orange
  elseif percent > 25 then
    color = yellow
  else
    color = green
  end
  return white .. 'CPU ' .. n .. ':' .. conky_lpad(3, numCmd) .. '%  ' .. color .. barCmd
end

function conky_color_cpu_total(n)
  numCmd = '${cpu cpu0}'
  barCmd = '${cpubar cpu0 10}'

  percent_str = string.match(conky_parse(numCmd), '[0-9]+')
  percent = tonumber(percent_str)

  if percent > 75 then
    color = red
  elseif percent > 50 then
    color = orange
  elseif percent > 25 then
    color = yellow
  else
    color = green
  end
  return white .. 'Total:' .. conky_lpad(3, numCmd) .. '%  ' .. color .. barCmd
end

function conky_color_ram(s)
  cmd = '${membar 10}'

  percent_str = string.match(conky_parse(s), '[0-9.]+')
  percent = tonumber(percent_str)

  if percent > 14 then
    color = red
  elseif percent > 10 then
    color = orange
  elseif percent > 8 then
    color = yellow
  else
    color = green
  end
  return color .. cmd
end

function conky_color_swap(s)
  cmd = '${swapbar 10}'

  status = conky_parse(s)

  mb = string.match(status, 'MiB')
  if mb ~= nil then
    return green .. cmd
  end

  percent_str = string.match(status, '[0-9]+')
  percent = tonumber(percent_str)

  if percent > 20 then
    color = red
  elseif percent > 10 then
    color = orange
  elseif percent > 5 then
    color = yellow
  else
    color = green
  end
  return color .. cmd
end
