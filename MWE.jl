using WGLMakie # OK with GLMakie

function test(n,nh)
    fig = Figure()
    ax = Axis(fig[1,1])
    x = [(i-1)*2π/(n-1) for i in 1:n]
    y = sin.(x)
    xn = Observable(y)

    scatter!(ax,lift(x -> x , xn),markersize=5,color = :red)
    lines!(ax,lift(x -> x , xn),color = :blue)

    display(fig)
	foreach(1:nh) do j
          y .= sin.(x .+ 2π*j/nh) 
          xn[] = y
          yield()
	  sleep(.1)
	end
end

test(100,100)
