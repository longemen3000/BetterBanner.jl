module BetterBanner
function banner(io = stdout)
    GIT_VERSION_INFO = Base.GIT_VERSION_INFO
    if GIT_VERSION_INFO.tagged_commit
        commit_string = Base.TAGGED_RELEASE_BANNER
    elseif isempty(GIT_VERSION_INFO.commit)
        commit_string = ""
    else
        days = Int(floor((ccall(:jl_clock_now, Float64, ()) - GIT_VERSION_INFO.fork_master_timestamp) / (60 * 60 * 24)))
        days = max(0, days)
        unit = days == 1 ? "day" : "days"
        distance = GIT_VERSION_INFO.fork_master_distance
        commit = GIT_VERSION_INFO.commit_short

        if distance == 0
            commit_string = "Commit $(commit) ($(days) $(unit) old master)"
        else
            branch = GIT_VERSION_INFO.branch
            commit_string = "$(branch)/$(commit) (fork: $(distance) commits, $(days) $(unit))"
        end
    end
    empty_str = ""
    logoplusspace = 26
    commit_date = isempty(Base.GIT_VERSION_INFO.date_string) ? "" : "($(split(Base.GIT_VERSION_INFO.date_string)[1]))"
    doc = "Documentation:"
    doc_link = "https://docs.julialang.org"
    general_help = """Type "?" for help"""
    pkg_help = """"]?" for Pkg help."""
    _,width = displaysize(io)
    if width >= 67
        t1 = empty_str
        t2 = doc * " " * doc_link
        t3 = empty_str
        t4 = general_help * ", " * pkg_help
        t5 = empty_str
        t6 = "Version $(Base.VERSION) $(commit_date)"
        t7 = commit_string
        t8 = empty_str
        extra = """
        
        """
    elseif 44 <= width <= 67
        t1 = doc
        if width >= 52
            t2 = doc_link
        else
            t2 = "docs.julialang.org"
        end
        t3 = empty_str
        t4 = general_help * ","
        t5 = pkg_help
        t6 = empty_str
        version_str = "Ver. $(Base.VERSION) $commit_date"
        if length(version_str) + logoplusspace < width
            t7 = version_str
            t8 = empty_str
        else
            t7 = "Ver. $(Base.VERSION)"
            t8 = commit_date
        end
        extra = """
        
        $commit_string
        
        """
    else
        t1 = empty_str
        t2 = empty_str
        t3 = empty_str
        t4 = empty_str
        t5 = empty_str
        t6 = empty_str
        t7 = empty_str
        t8 = empty_str
        #expect overflowing, but the logo is unaffected
        extra = """
        
        $doc 
        $doc_link

        $(general_help), $pkg_help

        Ver. $(Base.VERSION) $commit_date
        
        $commit_string

        """
    end

    separator = ifelse(44 <= width, " | ",empty_str)
    tt1 = separator * t1
    tt2 = separator * t2
    tt3 = separator * t3
    tt4 = separator * t4
    tt5 = separator * t5
    tt6 = separator * t6
    tt7 = separator * t7
    tt8 = separator * t8
    if get(io, :color, false)
        c = Base.text_colors
        tx = c[:normal] # text
        jl = c[:normal] # julia
        d1 = c[:bold] * c[:blue]    # first dot
        d2 = c[:bold] * c[:red]     # second dot
        d3 = c[:bold] * c[:green]   # third dot
        d4 = c[:bold] * c[:magenta] # fourth dot

    

    print("""

                    $(d3)⢰⣿⣿⡆$(tx)   $(tt1)
                    $(d3)⠈⠛⠛⠁$(tx)   $(tt2)
     $(d1)⢰⣿⣿⡆$(jl)       ⣴⣾$(d2)⢰⣿⣿⡆$(d4)⢰⣿⣿⡆$(tx) $(tt3)  
     $(d1)⠈⠛⠛⠁$(jl)       ⣿⣿$(d2)⠈⠛⠛⠁$(d4)⠈⠛⠛⠁$(tx) $(tt4)
      ⣿⣿ ⣿⣿  ⣿⣿ ⣿⣿ ⣴⣾ ⣾⠟⠛⣿⣷$(tt5)
      ⣿⣿ ⣿⣿  ⣿⣿ ⣿⣿ ⣿⣿⢀⣴⡾⠋⣿⣿$(tt6)
      ⣿⣿ ⠙⢿⣶⠞⣿⣿ ⣿⣿ ⣿⣿⠈⠻⣷⣶⡿⣿$(tt7)
    ⢶⣦⣿⠟                   $(tt8)
    $(extra)""")
    else
        print("""  
                    ⢰⠉⠉⡆   $(tt1)
                    ⠈⠒⠒⠁   $(tt2)
     ⢰⠉⠉⡆       ⣴⣾⢰⠉⠉⡆⢰⠉⠉⡆ $(tt3)    
     ⠈⠒⠒⠁       ⣿⣿⠈⠒⠒⠁⠈⠒⠒⠁ $(tt4)
      ⣿⣿ ⣿⣿  ⣿⣿ ⣿⣿ ⣴⣾ ⣾⠟⠛⣿⣷$(tt5) 
      ⣿⣿ ⣿⣿  ⣿⣿ ⣿⣿ ⣿⣿⢀⣴⡾⠋⣿⣿$(tt6) 
      ⣿⣿ ⠙⢿⣶⠞⣿⣿ ⣿⣿ ⣿⣿⠈⠻⣷⣶⡿⣿$(tt7) 
    ⢶⣦⣿⠟                   $(tt8)
    $(extra)""")
    end

end
__precompile__()
function __init__()
    @eval begin
        Base.banner(io::IO=stdout) = BetterBanner.banner(io)
    end
end
end #module



