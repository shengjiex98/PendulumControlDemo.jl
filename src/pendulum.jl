using Printf
using GLMakie

"""
    pendulum_run(;fps=60)

Run a pendulum simulation at the given framerate.
"""
function pendulum_run(;fps=60)
    fig = Figure()
    ax = Axis(fig[1, 1], aspect=1)
    limits!(ax, [-1.5, 1.5], [-1.5, 1.5])

    x = Observable([π - 0.1, 0.0])
    θ = draw_pendulum!(ax, x)

    u = Observable(0.0)
    tooltip!(ax, 0, 0, @lift(@sprintf("Torque: %.3f", $u)), placement=:below)

    sl = Slider(fig[2, 1], range=-1:0.01:1, startvalue=0)

    m = 3
    l = 1
    g = 9.81
    b = 1
    #K = [-0.0941782  3.19134]
    K = [57  18]

    on(events(fig.scene).window_open) do event
        event || return
        frame = 0
        @async while isopen(fig.scene)
            w = -10 * sl.value[]
            if frame % 6 == 0
                xround = [rem(x[][1], 2π, RoundDown) - π, x[][2]]
                u[] = clamp((K * xround)[1], -10, 10)
            end

            dx = [x[][2];
                  (w - u[] - m * g * l * sin(x[][1]) - b * x[][2] ) / (m * l^2)]
            x[] = x[] + dx * 1/fps

            sleep(1/fps)
            frame += 1
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
