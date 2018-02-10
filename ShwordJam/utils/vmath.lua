local vmath = {}

function vmath.add(a, b)
    return {a[1] + b[1], a[2] + b[2]}
end

function vmul(a, s)
    return {a[1] * s, a[2] * s}
end
