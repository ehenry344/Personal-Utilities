-- // gilaga4815 // -- 

-- Module created with the help of many programming articles and devforum documentation with useful methods

--[[
	This module serves as an extension for existing table functions to be able to clean up some functions that are reused
]]

--------------------------------------------------------------------------------------------------------------------------------------------

-- parameters of the dictionaryCompare method (Found on the Developer Forums (Credits : goldenstein64)) 

-- dict1 : the dictionary you want to compare against t1
-- dict2 : the dictionary you want to compare against t2

-- Basically what the method does is it checks if any parameter in t2 is different than any parameter in t1

--------------------------------------------------------------------------------------------------------------------------------------------

-- Parameters of the deepCopy method : (Found on developer hub (Credits : IgnisRBX @ DevRel))

-- tab is just the table you want deepcopied 

-- Basically this method just does is copies the table but it also copies every key in the table for embedded tables and whatnot

--------------------------------------------------------------------------------------------------------------------------------------------

-- Parameters of the shallowCopy method : (Found on developer hub (Credits : IgnisRBX @ DevRel))

-- tab is just the table you want shallowcopied

-- Basically this method just does is it copies the table, however it may not copy embedded tables 

--------------------------------------------------------------------------------------------------------------------------------------------

-- Parameters of the clear method : (Credits : gilaga4815)

-- tab is just the table you want to be cleared

-- Basically this method just clears every index in the table pretty self explanatory

--------------------------------------------------------------------------------------------------------------------------------------------

-- Parameters of the getPrecedence method : (Credits : gilaga4815)

-- tab is just the table you want to get the next index of

-- Basically this method just goes through the table and tells you the next index, if that index is at the end of the table than it 
-- just returns back to the 1st index

--------------------------------------------------------------------------------------------------------------------------------------------

-- Parameters of the generateChunks method : (Credits : Ryan Farney dev.to)

-- tab is just the table you want to create chunks from

-- Basically this method iterates / steps through all of the elements in the table 
-- as it steps through all of the elements in the table it checks if there is no subtable in the chunked table or that the length
-- of the table at the last indice is the same as the size of the chunks a user wants
-- if so than a new table is added to the end and if it's not the same size as elements are added than elements are just added to it
-- without adding a new subtable to the chunked table

--------------------------------------------------------------------------------------------------------------------------------------------

-- Parameters of the stringifyTable method : (Credits : gilaga4815)

-- tab is just the table of the elements you want to format into a string

-- basically this method outputs a stringified version of all of the elements in the table in order, descending

--------------------------------------------------------------------------------------------------------------------------------------------

-- Parameters of the stringifyTable method : (Algorithim Idea Credits : sleitneck (aka crazyman32, Sleitneck on devforums)

-- tab is just the table in which you want reversed

-- basically this method reverses the elements in a table, so the ones at the end of the table will not be at the front of the table
-- and the elements at the front of the table are now at the end of the table

-- Warning : It returns a shallowcopy and doesn't actually update the table you are inputting it, just returns a shallowcopy.

--------------------------------------------------------------------------------------------------------------------------------------------

-- Parameters of the concatTable method : (Credits gilaga4815)

-- The (...) is just a variable number of arguments, stating the data being passed in (i.e. tables)

-- basically this function simply concatenates or appends the data from one table onto another and returns it

--------------------------------------------------------------------------------------------------------------------------------------------

-- Parameters of the concatNTable method : (Credits gilaga4815)

-- the (...) or variable number of arguments are just add'l arguments that can be passed 

-- This function simply concatenates all of the tabular data provided into one big table, and returns it 

-- Warning : This method is costly for that of a utility function, so use sparingly

--------------------------------------------------------------------------------------------------------------------------------------------

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

-- Added 12 / 2 / 2021 
tableModule.concatTable = function(...)
	local newTab = {}
	
	for _,v in pairs({...}) do
		for _, x in pairs(v) do
			newTab[#newTab + 1] = x
		end
	end
	
	return newTab 
end

local function unwrapTable(tab) -- used within the method below 
	if type(tab[1]) == "table" then
		return unwrapTable(tab[1])
	end
	
	return tab 
end

-- Added 12 / 2 / 2021 
tableModule.concatNTable = function(...)		
	local newTab = {} 
	
	for _, extraData in pairs({...}) do 
		for index, tableContents in pairs(extraData) do
			if type(tableContents) ~= "table" then
				newTab[#newTab + 1] = tableContents
			else 
				newTab = tableModule.concatNTable(
					newTab, 
					unwrapTable(tableContents)
				)
			end
		end
	end
	
	return newTab 
end

return tableModule
