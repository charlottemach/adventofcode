#!/usr/bin/julia

mutable struct Dir
    name::String
    size::Number
    subdirs::Dict{String,Dir} # Array{Dir}
end

function add_dir(dir, dict)
    if (.!haskey(dict, dir.name) || dir.size > 0)
        dict[dir.name] = dir
    end
    return dict
end

function print_dirs(dirs,indent)
    println(repeat(".",indent),dirs.name, " - ",dirs.size)
    for (name,dir) in dirs.subdirs
        print_dirs(dir,indent+1)
    end
end

function get_parent_dir(path, dirs)
    path = [s for s in split(path, "/") if s!= ""]
    for p in path
        dirs = dirs.subdirs[p]
    end
    return dirs
end

function get_dir_sizes(f,sizes)
    if length(f.subdirs) == 0
        return f.size,sizes
    end
    s = 0
    for (n,d) in f.subdirs
        size,sizes = get_dir_sizes(d,sizes)
        s += size
    end
    push!(sizes,s)
    return s,sizes
end

function read_file(input)
    files = Dir("",0,Dict{String,Dir}())
    cur_dir = files
    path = ""
    open(input,"r") do i
        for line in eachline(i)
            file = split(line, " ")
            if (startswith(line, "\$ cd"))
                to = file[3]
                if (to == "..")
                    path = SubString(path, 1, length(path)-length(cur_dir.name)-1)
                    cur_dir = get_parent_dir(path,files)
                elseif (to == "/")
                    cur_dir = files
                    path = "/" 
                else
                    newDir = Dir(to,0,Dict{String,Dir}())
		    cur_dir.subdirs = add_dir(newDir,cur_dir.subdirs)
                    cur_dir = cur_dir.subdirs[to]
                    path = path * cur_dir.name * "/"
                end
            elseif (startswith(line, "\$ ls") || startswith(line, "dir"))
                # println(line)
            else
                newDir = Dir(file[2],parse(Int64,file[1]),Dict{String,Dir}())
                cur_dir.subdirs = add_dir(newDir,cur_dir.subdirs)
            end
        end
    end
    return files
end

function main()
    files = read_file("seven.txt")
    # print_dirs(files,0)

    used,sizes = get_dir_sizes(files,[])
    free = 30000000 - (70000000 - used)

    println("A: ",sum([x for x in sizes if x<100000]))
    println("B: ",minimum(filter(n -> n > free, sizes)))
end

main()
