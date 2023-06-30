module PublicationFiguresMakie

using Makie
using Colors, ColorSchemes

export Publication
export SinglePlot, SingleColumn, TwoColumns
export palette 

palette(colors::Symbol, n::Int) = get(colorschemes[colors], range(0,1,length=n))

_MARKERS = [
    :circle, :rect, :diamond,
    :utriangle, :dtriangle, :rtriangle, :ltriangle,
    :hexagon, :pentagon, :cross, :xcross,
    :star4, :star5, :star6, :star8
]
_COLORSCHEME = colorschemes[:Dark2_8]

Publication = Theme(
    #= global properties =#
    fontsize = 32,
    palette = (
        color = _COLORSCHEME,
        marker = _MARKERS,
        linestyle = :solid,
    ),
    Axis = (
        xgridvisible = false,
        ygridvisible = false,
        xticksize = -10,
        yticksize = -10,
        xminorticksvisible = true,
        yminorticksvisible = true,
        xminorticksize = -5,
        yminorticksize = -5,
        xticksmirrored = true,
        yticksmirrored = true,
    ),
    Legend = (
        framevisible = false,
        titlefont = :regular,
        titlesize = 28,
        labelsize = 28,
    ),
    Colorbar = (
        ticksvisible = false,
    ),

    #= plot-specific properties =#
    Lines = (
        linewidth = 4,
        cycle = Cycle([:color])
    ),

    Scatter = (
        markersize = 16,
        cycle = Cycle([:color, :marker], covary=true)
    ),

    ScatterLines = (
        linewidth = 4,
        markersize = 16,
        cycle = Cycle([:color, :marker], covary=true)
    ),

    Series = (
        linewidth = 4,
        color = _COLORSCHEME.colors
    )
)

SinglePlot() = (800, 600)
SingleColumn(n) = (800, 600*n)
TwoColumns(n) = (1600, 600*n)


function demo_plot_single()
    x = range(-2, +2, length=200)
    k = 0.5:0.5:3
    y = @. sinc(k' * x) 
    fig = Figure(resolution = SinglePlot())
    ax = Axis(fig[1,1])
    for (i,k) in enumerate(k)
        lines!(ax, x, y[:,i], label="$k")
    end
    ax.xlabel = "φ"
    ax.ylabel = "sinc(kφ)"
    axislegend("k", position=:rt)
    fig
end

function demo_plot_twocolumns()
    x = range(0.01, 1, length=30)
    k = [2, 3, 4, 6]
    y = @. x^2 * exp(-k'*x)
    z = @. - x^2 * exp(-k'*x)

    fig = Figure(resolution = TwoColumns(1))

    axr = Axis(fig[1,2])
    series!(axr, x, z')
    axr.xlabel = "x"
    axr.ylabel = "z"
    axr.xscale = log10

    axl = Axis(fig[1,1])
    for (i,k) in enumerate(k)
        scatterlines!(axl, x, y[:,i], label="$k")
    end
    axl.xlabel = "τ / Tₛ"
    axl.ylabel = "y"

    fig
end

end
