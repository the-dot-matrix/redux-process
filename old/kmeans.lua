K = 12
points,centroids,clusters = nil,nil,nil
clustering,converged = false,false
local colors = {
    {1,0,0,0.5},
    {1,1,0,0.5},
    {0,1,0,0.5},
    {0,1,1,0.5},
    {0,0,1,0.5},
    {1,0,1,0.5},
    {1,0,0,0.5},
    {1,1,0,0.5},
    {0,1,0,0.5},
    {0,1,1,0.5},
    {0,0,1,0.5},
    {1,0,1,0.5}
}
function pixel2point(x, y, r, g, b, a)
    if r==1 and g==1 and b==1 then
        table.insert(points, {x,y})
    end
    return r, g, b, a
end
function kmeans_init()
    centroids = {}
    for k=1,K do
        -- Initialization: choose k centroids (Forgy, Random Partition, etc.)
        -- centroids = [c1, c2, ..., ck]
        table.insert(centroids,points[love.math.random(1,#points)])
    end
end
function image2points(imagedata)
    points = {}
    imagedata:mapPixel(pixel2point,0,0,imagedata:getWidth(),imagedata:getHeight())
    kmeans_init()
end

function distance(p1,p2)
    return math.sqrt(math.pow(math.abs(p1[1]-p2[1]),2)+math.pow(math.abs(p1[2]-p2[2]),2))
end
function cluster(p)
    local assignment,mindist
    -- distances_to_each_centroid = [distance(point, centroid) for centroid in centroids]
    for k=1,K do
        local dist = distance(p,centroids[k])
        -- cluster_assignment = argmin(distances_to_each_centroid)
        if not mindist or dist<mindist then
            mindist = dist
            assignment = k
        end
    end
    return assignment
end
function centroid(cluster)
    -- #   (the standard implementation uses the mean of all points in a
    -- #     cluster to determine the new centroid)
    local x,y=0,0
    for i,p in ipairs(cluster) do
       x=x+p[1]
       y=y+p[2]
    end
    return {x/#cluster,y/#cluster}
end
function kmeans_iter()
    -- # Clear previous clusters
    -- clusters = [[] for _ in range(k)]
    clusters = {}
    for k=1,K do table.insert(clusters,{}) end
    -- # Assign each point to the "closest" centroid 
    -- for point in points:
    for i,p in ipairs(points) do
        -- clusters[cluster_assignment].append(point)
        table.insert(clusters[cluster(p)],p)
    end
    -- # Calculate new centroids
    local changed = false
    for k=1,K do
        -- new_centroids = [calculate_centroid(cluster) for cluster in clusters]
        local recentroid = centroid(clusters[k])
        -- converged = (new_centroids == centroids)
        changed = changed or centroids[k][1]~=recentroid[1] or centroids[k][2]~=recentroid[2]
        -- centroids = new_centroids
        centroids[k]=recentroid
    end
    converged = not changed
end

function kmeans_draw()
    if clusters and centroids then 
        for k=1,K do
            love.graphics.setColor(colors[k])
            if clusters[k] then
                local x1,x2,y1,y2
                for i,p in ipairs(clusters[k]) do
                    if not x1 or p[1]<x1 then x1=p[1] end
                    if not x2 or p[1]>x2 then x2=p[1] end
                    if not y1 or p[2]<y1 then y1=p[2] end
                    if not y2 or p[2]>y2 then y2=p[2] end
                    if x1 and x2 and y1 and y2 then
                        love.graphics.rectangle("fill",p[1],p[2],1,1)
                    end
                end
                if x1 and x2 and y1 and y2 then
                    love.graphics.rectangle("line",x1-0.5,y1-0.5,x2-x1+2,y2-y1+2)
                end
            end
            if centroids[k] then
                love.graphics.rectangle("line",centroids[k][1],centroids[k][2],2,2)
                love.graphics.rectangle("line",centroids[k][1],centroids[k][2],2,2)
            end
        end 
    end
end
