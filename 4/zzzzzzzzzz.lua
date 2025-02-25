local colony = peripheral.wrap("back")

local citizens = colony.getCitizens()

local job_counts = {}
for _, cit in pairs(citizens) do
    local job = cit.work.job
    print(job)
    if job_counts[job] == nil then
        --table.insert(job_counts, job)
        --job_counts[job] = 0
        job_counts[job] = 0
    end
    job_counts[job] = job_counts[job] + 1
end

for k,v in pairs(job_counts) do
    --print("SAM")
    --print(v)
    if v > 1 then
        print(v, k)
    end
end        
    
