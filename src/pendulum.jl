using SimpleDirectMediaLayer
using SimpleDirectMediaLayer.LibSDL2

function pendulum_run()
    SDL_GL_SetAttribute(SDL_GL_MULTISAMPLEBUFFERS, 16)
    SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES, 16)

    @assert SDL_Init(SDL_INIT_EVERYTHING) == 0 "error initializing SDL: $(unsafe_string(SDL_GetError()))"

    win = SDL_CreateWindow("Control Demo", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 1000, 1000, SDL_WINDOW_SHOWN)
    SDL_SetWindowResizable(win, SDL_TRUE)

    renderer = SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC)

    surface = IMG_Load(joinpath("src", "cat.png"))
    tex = SDL_CreateTextureFromSurface(renderer, surface)
    SDL_FreeSurface(surface)

    w_ref, h_ref = Ref{Cint}(0), Ref{Cint}(0)
    SDL_QueryTexture(tex, C_NULL, C_NULL, w_ref, h_ref)

    try
        w, h = w_ref[], h_ref[]
        pos = [(1000 - w) ÷ 2, (1000 - h) ÷ 2]
        dest_ref = Ref(SDL_Rect(pos..., w, h))
        close = false
        speed = 300
        dirs = [0, 0]
        while !close
            event_ref = Ref{SDL_Event}()
            while Bool(SDL_PollEvent(event_ref))
                evt = event_ref[]
                if evt.type == SDL_QUIT
                    close = true
                    break
                elseif evt.type == SDL_KEYDOWN
                    scan_code = evt.key.keysym.scancode
                    if scan_code == SDL_SCANCODE_W || scan_code == SDL_SCANCODE_UP
                        dirs[2] -= 1
                        break
                    elseif scan_code == SDL_SCANCODE_A || scan_code == SDL_SCANCODE_LEFT
                        dirs[1] -= 1
                        break
                    elseif scan_code == SDL_SCANCODE_S || scan_code == SDL_SCANCODE_DOWN
                        dirs[2] += 1
                        break
                    elseif scan_code == SDL_SCANCODE_D || scan_code == SDL_SCANCODE_RIGHT
                        dirs[1] += 1
                        break
                    else
                        break
                    end
                elseif evt.type == SDL_KEYUP
                    scan_code = evt.key.keysym.scancode
                    if scan_code == SDL_SCANCODE_W || scan_code == SDL_SCANCODE_UP
                        dirs[2] += 1
                        break
                    elseif scan_code == SDL_SCANCODE_A || scan_code == SDL_SCANCODE_LEFT
                        dirs[1] += 1
                        break
                    elseif scan_code == SDL_SCANCODE_S || scan_code == SDL_SCANCODE_DOWN
                        dirs[2] -= 1
                        break
                    elseif scan_code == SDL_SCANCODE_D || scan_code == SDL_SCANCODE_RIGHT
                        dirs[1] -= 1
                        break
                    else
                        break
                    end
                end
            end

            dirs = max.(dirs, [-1, -1])
            dirs = min.(dirs, [1, 1])
            pos += speed / 30 * dirs
            pos = max.(pos, [0, 0])
            pos = min.(pos, [1000 - w, 1000 - h])

            dest_ref[] = SDL_Rect(pos..., w, h)
            SDL_RenderClear(renderer)
            SDL_RenderCopy(renderer, tex, C_NULL, dest_ref)
            dest = dest_ref[]
            pos[1], pos[2], w, h = dest.x, dest.y, dest.w, dest.h
            SDL_RenderPresent(renderer)

            SDL_Delay(1000 ÷ 60)
        end
    finally
        SDL_DestroyTexture(tex)
        SDL_DestroyRenderer(renderer)
        SDL_DestroyWindow(win)
        SDL_Quit()
    end
end
