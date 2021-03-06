-- This is some code to show a few ways how the file APIs in Iguana can be
-- used to deal with large files where you might want to process a little bit at a
-- time.

-- Normally real production code would use helper functions.

-- http://help.interfaceware.com/v6/streaming-file-operations

local stream = require 'stream'

local SomeRandomData=[[
This is some random data to save to a file
with a few lines.
]]

function main()
   stream.toString(
   -- Iguana's 'working directory' can be 
   -- found using this function
   iguana.workingDir()

   -- Let's stream to file one incredibly long content 
	-- https://github.com/interfaceware/iguana-file/blob/master/shared/stream.lua
   stream.toFile("exampletext.txt", stream.fromString(SomeRandomData))

   -- Now open it for reading with iterator, by lines
   local F = io.open("exampletext.txt", "r")
   local Content = {}
   for line in F:lines() do
      trace(line)
      Content[#Content+1] = line
      -- add processing here
   end 
   F:close()
   trace(Content)

   -- Now open it for reading as field length delimited data
   -- read only 7 characters at a time.
   local F = io.open("exampletext.txt", "r")
   local Content = {}
   local line
   repeat
      line = F:read(7)
      trace(line)
      Content[#Content+1] = line
      -- add processing here
   until not line 
   F:close()
   trace(Content)
   -- Enjoy!
end
