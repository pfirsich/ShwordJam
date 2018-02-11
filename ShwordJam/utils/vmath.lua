local vmath = {}

function vmath.vec(x, y)
    return {x, y}
end

function vmath.add(a, b)
    return {a[1] + b[1], a[2] + b[2]}
end

function vmath.mul(a, s)
    return {a[1] * s, a[2] * s}
end

function vmath.copy(v)
    return {v[1], v[2]}
end

function vmath.len(v)
    return math.sqrt(v[1]*v[1] + v[2]*v[2])
end

return vmath
