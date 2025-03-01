local colony_device = "back"

local colony = peripheral.wrap(colony_device)

local citizens = colony.getCitizens()

function merge_tables(table1, table2)
    table3 = {}
    for _, v in pairs(table1) do
        table.insert(table3, v)
    end
    for _, v in pairs(table2) do
        table.insert(table3, v)
    end
    return table3
end

function get_cits_by_job(job_name)
    local filtered_cits = {}
    for _, cit in pairs(citizens) do
        job = cit.work.job
        if string.find(job, job_name) then
            --print(cit.name)
            table.insert(filtered_cits, cit)
        end
    end
    return filtered_cits
end

function get_cits_by_name(name_name)
    local filtered_cits = {}
    for _, cit in pairs(citizens) do
        name = cit.name
        if string.find(name, name_name) then
            table.insert(filtered_cits, cit)
        end
    end
    return filtered_cits
end


ca_cits = get_cits_by_job("combattraining")
kn_cits = get_cits_by_job("knight")
f_cits = merge_tables(ca_cits, kn_cits)

local f_c = 0
for _, v in pairs(f_cits) do
    f_c = f_c + 1
end
--print(f_c)
--sleep(10)

--for k,v in pairs(f_cits) do print(v.work.job) sleep(.2) end
--print(f_cits[1].state)
--print(f_cits[1].name)
cit_name = "Julieta"
local ff_c = get_cits_by_name(cit_name)
local l = ff_c[1].location
print(l.x, l.y, l.z)

--sleep(2)
for k, v in pairs(f_cits[1]) do
    --print(k,v)
    --sleep(.2)
end

for k,v in pairs(colony) do
    --print(k,v)
    --sleep(1)
end
