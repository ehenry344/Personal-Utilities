--[[

        _ _                   _  _    ___  _ ____  
   __ _(_) | __ _  __ _  __ _| || |  ( _ )/ | ___| 
  / _` | | |/ _` |/ _` |/ _` | || |_ / _ \| |___ \ 
 | (_| | | | (_| | (_| | (_| |__   _| (_) | |___) |
  \__, |_|_|\__,_|\__, |\__,_|  |_|  \___/|_|____/ 
  |___/           |___/    


Table Utility Module 

Last Update : 12 / 16 / 2021 

Module Description : 

- Provides added functionality for things that are missing from the important lua table library 
- Some of the functions within this module are sourced from many different places, so authors are credited in the function reference
]]

--[[
TableExtension Function Documentation : 

1. dictionaryCompare(table: dictionary1, table: dictionary2) (Credits : goldenstein64)
	-- accepts two different tables / dictionaries and checks if their complementing keys are equal 
	-- return : true if their comparisons fulfill, false otherwise 
	
2. deepCopy(table: tab) (Credits : IgnisRBX)
	- creates a copy of a table with embeded tables 
	- return : the deepcopied table 
	
3. shallowCopy(table: tab) (Credits : IgnisRBX)
	-- creates a copy of a 1d table 
	-- return : the shallowcopied table 

4. clear(table: tab) (Credits : gilaga4815)
	-- sets all elements of the table to nil, effectively clearing the data 
	-- return : nil 

5. getPrecedence(table: tab, number: current) : (Credits : gilaga4815)
	-- acts as a cyclic table indexer, meaning if the current number is the last element in the table it will return the 
	-- first element of the table, otherwise it returns the next one, prevents attempting to index an unfilled position
	
6. generateChunks(table: tab, number: chunkSize) (Credits : Ryan Farney dev.to)
	-- generates a table with separate subtables, each subtable holds a maximum number of elements that is set by the chunkSize
	-- return : the table that was chunked
	
7. stringifyTable(table: tab) (Credits : gilaga4815)
	-- creates a string that represents the contents of the table
	-- return : the string as stated above 
	
8. reverse(table: tab) (Credits : sleitnick)
	-- creates a shallowcopied version of the table and reverses the order of the elements in each numerical position
	-- return : shallowCopied table that holds reversed data from input

8. concatTable(table: ...) (Credits : gilaga4815)
	-- accepts as many tables as allowed as input, concatenats them all together into one big table
	-- return : table with all concatenated data from other tables (Warning : This is a shallow concatenation)
	
9. flatten(table: tab) (Credits : gilaga4815)
	-- flattens (compresses subtables into one table) the contents of a table with potential subtables into a single table 
	-- returns the table with the unpacked data (Warning: this is a new table)
	
10. deepConcat(table: ...) (Credits : gilaga4815) 
	-- works similarily to that of concatTable, however this function can also concatenate tables with embedded tables, so everything gets added 
	-- return : the deep concatenated table 
]]

local tableModule = {}

tableModule.dictionaryCompare = function(dict1, dict2)	
	for key, value in pairs(dict1) do
		if dict2[key] ~= value then
			return false
		end
	end

	return true 
end

tableModule.deepCopy = function(tab) -- this function will generate and return a copy of a table for ease of use
	local copy = {}

	for i, v in pairs(tab) do
		if type(v) == "table" then
			v = tab(v)
		end
		copy[i] = v
	end

	return copy
end

tableModule.shallowCopy = function(tab)
	local copiedTable = {}

	for i,v in pairs(tab) do
		copiedTable[i] = v
	end

	return copiedTable
end

tableModule.clear = function(tab)
 	for key in pairs(tab) do
		tab[key] = nil
	end
end

tableModule.getPrecedence = function(tab, current)
	local cPstn = table.find(tab, current)
	if (cPstn) > #tab then
		return tab[1]
	else
		return tab[cPstn + 1] 
	end
end

tableModule.generateChunks = function(tab, chunkSize)
	local chunkedTable = {}

	for i = 1, #tab do
		local lastAvailableChunk = chunkedTable[#chunkedTable] 
		if (not lastAvailableChunk or #lastAvailableChunk == chunkSize) then 
			chunkedTable[#chunkedTable + 1] = {tab[i]}
		else
			lastAvailableChunk[#lastAvailableChunk + 1] = tab[i] 
		end
	end

	return chunkedTable
end
 
tableModule.stringifyTable = function(tab)
	local stringifiedTable = ""
	
	for i,v in pairs(tab) do
		stringifiedTable = stringifiedTable .. "\n" .. tostring(v)
	end
	return stringifiedTable
end

tableModule.reverse = function(tab)
	local copiedTable = tableModule.shallowCopy(tab)
	
	for i = 1, #copiedTable do
		copiedTable[i] = tab[#tab - (i - 1)]
	end
	
	return copiedTable
end

tableModule.concatTable = function(...)
	local newTab = {}
	
	for _,v in pairs({...}) do
		for _, x in pairs(v) do
			newTab[#newTab + 1] = x
		end
	end
	
	return newTab 
end

tableModule.flatten = function(tab) 
	local newTable = {} 
	
	local function unpackSub(privateT)
		for i = 1, #privateT do
			if type(privateT[i]) == "table" then
				unpackSub(privateT[i])
			else
				table.insert(newTable, privateT[i])
			end
		end
	end
	
	unpackSub(tab)	
	return newTable 
end

tableModule.deepConcat = function(...)		
	local newTab = {} 
	
	for _, extraData in pairs({...}) do 
		for index, tableContents in pairs(extraData) do
			if type(tableContents) ~= "table" then
				newTab[#newTab + 1] = tableContents
			else 
				newTab = tableModule.deepConcat(
					newTab, 
					tableModule.flatten(tableContents)
				) 
			end
		end
	end
	
	return newTab 
end

return tableModule
