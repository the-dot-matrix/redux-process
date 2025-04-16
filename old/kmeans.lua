local KMEANS = {}
KMEANS.K = 12
KMEANS.colors = {
    {0.50,  0.00,  0.00,    0.5},
    {0.50,  0.50,  0.00,    0.5},
    {0.00,  0.50,  0.00,    0.5},
    {0.00,  0.50,  0.50,    0.5},
    {0.00,  0.00,  0.50,    0.5},
    {0.50,  0.00,  0.50,    0.5},
    {0.50,  0.25,  0.00,    0.5},
    {0.50,  0.50,  0.25,    0.5},
    {0.00,  0.50,  0.25,    0.5},
    {0.25,  0.50,  0.50,    0.5},
    {0.25,  0.00,  0.50,    0.5},
    {0.50,  0.25,  0.50,    0.5}
}
function KMEANS.init(w,h)
    KMEANS.converged = false
    KMEANS.centroids = {}
    KMEANS.shader = love.graphics.newShader("gpu/kmeans.glsl")
    for k=1,KMEANS.K do
        table.insert(KMEANS.centroids,{love.math.random(0,w),love.math.random(0,h)})
    end
    KMEANS.shader:send("centroids", unpack(KMEANS.centroids))
end
function KMEANS.cluster(x, y, r, g, b, a)
    for k,v in ipairs(KMEANS.colors) do
        local color = KMEANS.colors[k]
        if math.abs(r-color[1])<0.05 and math.abs(g-color[2])<0.05 and math.abs(b-color[3])<0.05 and a>0 then
            KMEANS.clusters[k]["x"] = KMEANS.clusters[k]["x"] + x
            KMEANS.clusters[k]["y"] = KMEANS.clusters[k]["y"] + y
            KMEANS.clusters[k]["n"] = KMEANS.clusters[k]["n"] + 1
        end
    end
    return r, g, b, a
end
function KMEANS.centroid(imagedata)
    local w,h = imagedata:getWidth(),imagedata:getHeight()
    local changed = false
    imagedata:mapPixel(KMEANS.cluster,0,0,w,h)
    for k=1,KMEANS.K do
        local x = math.floor(KMEANS.clusters[k]["x"]/KMEANS.clusters[k]["n"])
        local y = math.floor(KMEANS.clusters[k]["y"]/KMEANS.clusters[k]["n"])
        local recentroid = {x,y}
        changed = changed or KMEANS.centroids[k][1]~=recentroid[1] or KMEANS.centroids[k][2]~=recentroid[2]
        KMEANS.centroids[k]=recentroid
    end
    KMEANS.converged = not changed
end
function KMEANS.iter(imagedata)
    KMEANS.clusters = {}
    for k=1,KMEANS.K do
        table.insert(KMEANS.clusters,{x=0,y=0,n=0})
    end
    KMEANS.centroid(imagedata)
    KMEANS.shader:send("centroids", unpack(KMEANS.centroids))
end

return KMEANS
