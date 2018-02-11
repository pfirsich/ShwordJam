local utils = require("utils")
local GameObject = require("gameobject")

Platform = utils.class("Platform", GameObject)

function Platform:initialize(points, texture)
    print(utils.inspect(points))

    GameObject.initialize(self)
    local triangles = love.math.triangulate(points)
    local vertices = {}
    local textureScale = 0.1
    for t = 1, #triangles do
        for v = 1, 6, 2 do
            table.insert(vertices,  {
                triangles[t][v+0],
                triangles[t][v+1],

                triangles[t][v+0] * textureScale,
                triangles[t][v+1] * textureScale,
            })
        end
    end
    self.mesh = lg.newMesh(vertices, "triangles", "static")
    if texture then
        self.mesh:setTexture(texture)
    end

    self.shape = GameObject.collider:polygon(points)
end

function Platform:update()

end

function Platform:draw()
    lg.draw(self.mesh)
end

return Platform
