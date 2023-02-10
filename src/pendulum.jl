using GLMakie

"""
    pendulum_run(;fps=60)

Run a pendulum simulation at the given framerate.
"""
function pendulum_run(;fps=60)
    fig = Figure()
    ax = Axis(fig[1, 1], aspect=1)
    limits!(ax, [-1.5, 1.5], [-1.5, 1.5])

    θ = draw_pendulum!(ax)

    sl = Slider(fig[2, 1], range=-1:0.01:1, startvalue=0)

    on(events(fig.scene).window_open) do event
        event || return
        @async while isopen(fig.scene)
            θ[] += sl.value[] / 10
            sleep(1/fps)
        end
    end

    fig
end

"""
    draw_pendulum!(ax::Axis)

Draw a unit length pendulum on the given axis.  Returns θ, the angle of the pendulum from
vertical.
"""
function draw_pendulum!(ax::Axis)
    θ = Observable(0.0)
    pend = @lift(Point2f(sin($θ), -cos($θ)))
    points = @lift([Point2f(0, 0), $pend])

    lines!(ax, points)
    poly!(ax, @lift(Circle($pend, 0.1)))

    θ
end
