
# @author Isaiah Odhner

lerp = (a, b, b_ness)->
	a + (b - a) * b_ness

rand = (a=1, b=0)->
	lerp(a, b, Math.random())

dist = (x1, y1, x2, y2)->
	Math.hypot(x2-x1, y2-y1)

circle = (gl, x, y, z, r, points=3*5)->
	gl.begin(gl.TRIANGLE_FAN)
	for i in [0..points]
		angle = Math.PI * 2 * i / points
		gl.vertex(
			x + Math.sin(angle) * r,
			y + Math.cos(angle) * r,
			z
		)
	gl.end()

tri = (gl, base_x, base_y, base_z, base_width, altitude, angle)->
	# TODO: z_tilt_angle?
	point_x = base_x + Math.sin(angle) * altitude
	point_y = base_y + Math.cos(angle) * altitude
	a_x = base_x + Math.sin(angle - Math.PI / 2) * base_width
	a_y = base_y + Math.cos(angle - Math.PI / 2) * base_width
	b_x = base_x + Math.sin(angle + Math.PI / 2) * base_width
	b_y = base_y + Math.cos(angle + Math.PI / 2) * base_width
	gl.color(1, 1, 0); gl.vertex(a_x, a_y, base_z)
	gl.color(0, 1, 1); gl.vertex(b_x, b_y, base_z)
	gl.color(1, 0, 1 * Math.random()); gl.vertex(point_x, point_y, base_z + 0.5)

segment = (gl, base_x, base_y, base_z, width, length, angle)->
	a_1_x = base_x + Math.sin(angle - Math.PI / 2) * width
	a_1_y = base_y + Math.cos(angle - Math.PI / 2) * width
	b_1_x = base_x + Math.sin(angle + Math.PI / 2) * width
	b_1_y = base_y + Math.cos(angle + Math.PI / 2) * width
	a_2_x = base_x + Math.sin(angle - Math.PI / 2) * width + Math.sin(angle) * length
	a_2_y = base_y + Math.cos(angle - Math.PI / 2) * width + Math.cos(angle) * length
	b_2_x = base_x + Math.sin(angle + Math.PI / 2) * width + Math.sin(angle) * length
	b_2_y = base_y + Math.cos(angle + Math.PI / 2) * width + Math.cos(angle) * length
	# gl.color(0.7, 0.3, 0)
	gl.vertex(a_1_x, a_1_y, base_z)
	gl.vertex(b_1_x, b_1_y, base_z)
	gl.vertex(a_2_x, a_2_y, base_z + 0.1)
	gl.vertex(a_2_x, a_2_y, base_z)
	gl.vertex(b_2_x, b_2_y, base_z)
	# gl.color(1, 0.5, 0.1)
	gl.vertex(b_1_x, b_1_y, base_z + 0.5)


class Thing
	constructor: (props={})->
		@x = 0
		@y = 0
		@z = 0
		@angle = 0
		@speed = 0.05
		# @angular_speed = 0
		# @z_speed = (Math.random() * 2 - 1) / 5
		@width = 5
		@[k] = v for k, v of props
	
	update: (t)->
		# @angular_speed += (Math.random() - 0.5) / 50
		# @angular_speed *= 0.99
		# @angle += @angular_speed
		prev_x = @x
		prev_y = @y
		# @x += Math.sin(@angle) * @speed
		# @y += Math.cos(@angle) * @speed
		# @z += @z_speed
		
		@x = Math.sin(Math.sin(t/50))
		# @y = Math.cos(Math.cos(t/50))
		@y = Math.cos(t/50/5) * 4
		
		dx = @x - prev_x
		dy = @y - prev_y
		
		@angle = Math.PI / 2 - Math.atan2(dy, dx)
	
	draw: (gl)->
		gl.begin(gl.TRIANGLES)
		# tri(gl, @x, @y, @z, 0.1 * Math.random(), 0.1 + 0.1 * Math.random(), @angle)
		# tri(gl, @x, @y, @z, 0.1 * @width, 0.1, @angle)
		# tri(gl, @x, @y, @z, 0.1 * @width, 0.1, @angle + Math.PI)
		gl.color(0, 0, 0, 1)
		# segment(gl, @x, @y, @z - 0.00009, 0.11 * @width, 0.1, @angle)
		segment(gl, @x, @y, @z - 0.1, 0.11 * @width, 0.1, @angle)
		gl.color(1, 1, 1, 1)
		segment(gl, @x, @y, @z, 0.1 * @width, 0.1, @angle)
		gl.end()


things = [new Thing(y: -4)]

t = 0
do @update = ->
	thing.update(t) for thing in things

@draw = (gl)->
	if t is 0
		gl.clearColor(rand(0.6, 1), rand(0.6, 1), rand(0.8, 1), 1)
		gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
	t += 1

	# gl.rotate(30, 1, 0, 0)
	
	thing.draw(gl) for thing in things
