local json = require "lib/json"
local vars = require "lib/constants"
local whi = require "lib/whi"
local sc = require "lib/sc"

local indexer = 'productivebees:gene_indexer_0'
local genes = 'productivebees:gene'

function LoadIndexer()
    local genes_found = 0

    -- genes_found = genes_found + whi.GetFromAnyWarehouse(false, genes, indexer, 64)
    genes_found = genes_found + sc.pull(genes, 64, false, indexer)
    if genes_found > 0 then print(genes_found, 'genes indexed') end
end

while true do
    if not pcall(LoadIndexer) then print('LoadIndexer() failed to complete') end
    -- LoadIndexer()
    sleep(60)
end