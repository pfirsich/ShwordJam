return {
    jump = {
        speed = 1,
        loop = false,
        keyFrames = {
            {
                _time = 0,
                scaleX = 1,
                scaleY = 1,
            },
            {
                _time = 0.08,
                scaleX = 1/0.8,
                scaleY = 0.8,
            },
            {
                _time = 0.19,
                scaleX = 0.8,
                scaleY = 1/0.85,
            },
            {
                _time = 1,
                scaleX = 1,
                scaleY = 1,
            },
        },
    },
    idle = {
        speed = 1,
        loop = true,
        keyFrames = {
            {
                _time = 0,
                scaleX = 1,
                scaleY = 1,
            },
            {
                _time = 0.5,
                scaleX = 0.85,
                scaleY = 0.95,
            },
            {
                _time = 1,
                scaleX = 1,
                scaleY = 1,
            },
        },
    },
}
