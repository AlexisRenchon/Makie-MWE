using GLMakie

fig = Figure(resolution = (1500,1500), backgroundcolor = :black)

ax = Axis(fig[1,1];
	  backgroundcolor = :black,
	  limits = (-10, 10, -10, 10),
	  title = "Snake",
	  titlecolor = :green,
	  titlesize = 50,
	  xlabelvisible = false,
	  ylabelvisible = false,
	  xticksvisible = false,
	  yticksvisible = false,
	  bottomspinecolor = :green,
	  topspinecolor = :green,
	  leftspinecolor = :green,
	  rightspinecolor = :green,
	  spinewidth = 5.0
	  )

Snake = Observable(Point2f([0.0, 0.0]))
x = Snake[][1]
y = Snake[][2]

Food = Observable(Point2f([rand()*10, rand()*10]))

pSnake = scatter!(Snake; 
	     markersize = 40,
	     color = :green,
	     marker = :rect
	     )

pFood = scatter!(Food;
		 markersize = 40,
		 color = :red,
		 marker = :rect
		 )

Speed = 0.1
global t = Timer(0)
on(events(fig).keyboardbutton) do event
  if event.action == Keyboard.press || event.action == Keyboard.repeat
    if event.key == Keyboard.up 
      close(t)
      x = Snake[][1]
      y = Snake[][2]
      f(timer) = (global y += 0.1; global Snake[] = Point2f([x, y]))
      global t = Timer(f, 0, interval = Speed)	     
    elseif event.key == Keyboard.down
      close(t)
      x = Snake[][1]
      y = Snake[][2]
      g(timer) = (global y -= 0.1; global Snake[] = Point2f([x, y]))
      global t = Timer(g, 0, interval = Speed)
    elseif event.key == Keyboard.left 
      close(t)
      x = Snake[][1]
      y = Snake[][2]
      h(timer) = (global x -= 0.1; global Snake[] = Point2f([x, y])) 
      global t = Timer(h, 0, interval = Speed)
    elseif event.key == Keyboard.right
      close(t)
      x = Snake[][1]
      y = Snake[][2]
      j(timer) = (global x += 0.1; global Snake[] = Point2f([x, y]))
      global t = Timer(j, 0, interval = Speed)
    end
  end
end

function distance(Food, Snake)
  sqrt((Food[][1] - Snake[][1] + Food[][2] - Snake[][2])^2)
end

Score = 0
function eat(timer)
  if distance(Food, Snake) < 1
    Food[] = Point2f([rand()*10, rand()*10])
    global Speed /= 1.2
    global Score += 1
  end
end
t2 = Timer(eat, 0, interval = Speed)

# to do: add score, top right corner
# to do: add tail

# tail: copy of where Snake was (score) second ago
Tail = Observable(Point2f([0.0, 0.0]))
xT = Tail[][1]
yT = Tail[][2]
pTail = scatter!(Tail; 
	     markersize = 40,
	     color = :green,
	     marker = :rect,
	     visible = false
	     )

function tail(timer)
  if Score > 0
    xT = Snake[][1]
    yT = Snake[][2]
    Tail[] = Point2f([xT, yT])
    pTail.visible = true
  end
end
t3 = Timer(tail, 2, interval = Speed)

# to do: on closing Makie window, close(t), close(t2), close(t3)


