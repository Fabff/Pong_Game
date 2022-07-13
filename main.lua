-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

local pad_left = {}
        pad_left.x = 0
        pad_left.y = 0
        pad_left.largeur = 20
        pad_left.hauteur = 80
        pad_left.speed = 2
        pad_left.score = 0
local pad_right = {}
        pad_right.x = 0
        pad_right.y = 0
        pad_right.largeur = 20
        pad_right.hauteur = 80
        pad_right.speed = 2
        pad_right.score = 0
local ball = {}
        ball.x = 0
        ball.y = 0
        ball.rayon = 10
        ball.vx = 0
        ball.vy = 0
        ball.speed = 2
local font = nil

function love.load()
  
  largeur_ecran = love.graphics.getWidth()
  hauteur_ecran = love.graphics.getHeight()

    --Police Font 
    font = love.graphics.newFont("varsity_regular.ttf", 120)
    --load pad left
    pad_left.x = 0
    pad_left.y = hauteur_ecran/2- pad_left.hauteur /2
    --load pad right
    pad_right.x = largeur_ecran - pad_right.largeur
    pad_right.y = hauteur_ecran/2- pad_right.hauteur/2
   
    --load ball
    restart()
end

function restart()
     --load ball
     ball.x = largeur_ecran/2+ball.rayon/2
     ball.y = hauteur_ecran/2+ball.rayon/2
     ball.vx = ball.speed
     ball.vy = ball.speed
end

function love.update(dt)
    --controle pad left
    if love.keyboard.isDown("a") and pad_left.y > 0 then 
        pad_left.y = pad_left.y - pad_left.speed*(60*dt)
    elseif love.keyboard.isDown("z") and pad_left.y < hauteur_ecran-pad_left.hauteur then
        pad_left.y = pad_left.y + 2*(60*dt)
    end
    --controle pad right
    if love.keyboard.isDown("up") and pad_right.y > 0 then 
        pad_right.y = pad_right.y - pad_right.speed*(60*dt)
    elseif love.keyboard.isDown("down") and pad_right.y < hauteur_ecran-pad_right.hauteur then
        pad_right.y = pad_right.y + 2*(60*dt)
    end
    --controle ball
    ball.x = ball.x + ball.vx*(60*dt)
    ball.y = ball.y + ball.vy*(60*dt)
    if ball.y > hauteur_ecran-ball.rayon then 
        ball.vy = 0-ball.vy
    end
    if ball.y < 0+ball.rayon then 
        ball.vy = 0-ball.vy
    end
    if ball.x < 0-ball.rayon then 
        pad_right.score = pad_right.score + 10
        restart()
    end
    if ball.x > largeur_ecran-ball.rayon then 
        pad_left.score = pad_left.score + 10
        restart()
    end
    --collision with right_pad
    if ball.x >= largeur_ecran - pad_right.largeur - ball.rayon then
        if ball.y > pad_right.y and ball.y < (pad_right.y + pad_right.hauteur) then 
            ball.vx = 0-ball.vx 
        end
    end
    --collision with left_pad
    if ball.x-ball.rayon <= (pad_left.x + pad_left.largeur) then
        if ball.y > pad_left.y and ball.y < (pad_left.y + pad_right.hauteur) then 
            ball.vx = 0-ball.vx 
        end
    end

end

function love.draw()
    love.graphics.setFont(font)
    love.graphics.print(pad_left.score, 20*(largeur_ecran/100), 5*(hauteur_ecran/100))
    love.graphics.print(pad_right.score, 70*(largeur_ecran/100), 5*(hauteur_ecran/100))
    --draw pad left and right
    love.graphics.rectangle("fill", pad_left.x, pad_left.y, pad_left.largeur, pad_left.hauteur)
    love.graphics.rectangle("fill", pad_right.x, pad_right.y, pad_right.largeur, pad_right.hauteur)
    love.graphics.circle("fill", ball.x, ball.y, ball.rayon)
    love.graphics.line(largeur_ecran/2, 0, largeur_ecran/2, hauteur_ecran)

end

function love.keypressed(key)
  print(key)
end
  