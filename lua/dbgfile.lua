-- TODO: generate variables from .dbg file

dbg {}

function dbg.dump(tab, fp)
    file = io.open(fp, "r")
    if file then
        dbgfile = file:read("*a")
        file:close()
    else
        print("Failed to open file")
    end

    -- build table contents from debugfile
end