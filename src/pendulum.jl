using GLMakie

"""
    pendulum_run(;fps=60)

Run a pendulum simulation at the given framerate.
"""
function pendulum_run(;fps=60)
    fig = Figure()
    ax = Axis(fig[1, 1], aspect=1)
    limits!(ax, [-1.5, 1.5], [-1.5, 1.5])

    x = Observable([0.0, 0.0])
    θ = draw_pendulum!(ax, x)

    sl = Slider(fig[2, 1], range=-1:0.01:1, startvalue=0)

    on(events(fig.scene).window_open) do event
        event || return
        @async while isopen(fig.scene)
            mr = 3; l = .19; g = 9.81; ; b = 0.1;
            I = 4/3*mr*l^2; 
            dx = [0.0; 0.0]
            dx[1] = x[][2];
            u = sl.value[]
            dx[2] = (u - mr * g * l * sin(x[][1]) - b * x[][2] ) / (I + mr * l^2);
            x[] = x[] + dx * 1/fps
            sleep(1/fps)
        end
    end

    on(events(fig.scene).joystickaxes[2]) do event
        if event !== nothing
            set_close_to!(sl, event[1])
        end
    end

    fig
end

"""
    draw_pendulum!(ax::Axis)

Draw a unit length pendulum on the given axis.  Returns θ, the angle of the pendulum from
vertical.
"""
function draw_pendulum!(ax::Axis, x)
    θ = @lift($x[1])
    pend = @lift(Point2f(sin($θ), -cos($θ)))
    points = @lift([Point2f(0, 0), $pend])

    lines!(ax, points)
    scatter!(ax, pend, marker=:circle, markersize=0.2, markerspace=:data)

    θ
end
