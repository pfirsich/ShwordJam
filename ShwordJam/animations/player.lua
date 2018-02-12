return {
    jump = {
        speed = 1.5,
        loop = false,
        keyFrames = {
            {
                _time = 0,
                y = 0,
                angle = 0.0 * math.pi,
                scaleX = 1,
                scaleY = 1,
            },
            {
                _time = 0.08,
                scaleX = 1/0.6,
                scaleY = 0.6,
            },
            {
                _time = 0.19,
                scaleX = 0.7,
                scaleY = 1/0.75,
            },
            {
                _time = 1,
                scaleX = 1,
                scaleY = 1,
            },
        },
    },

    dash = {
        speed = 1,
        loop = false,
        keyFrames = {
            {
                _time = 0,
                y = 0,
                angle = 0.0 * math.pi,
                scaleX = 1,
                scaleY = 1,
            },
            {
                _time = 0.15,
                scaleX = 0.5,
                scaleY = 0.4,
            },
            {
                _time = 0.3,
                scaleX = 0.8,
                scaleY = 0.7,
            },
            {
                _time = 1,
                angle = 6 * math.pi,
            },
        },
    },

    idle = {
        speed = 1,
        loop = true,
        keyFrames = {
            {
                _time = 0,
                y = 0,
                angle = 0.0 * math.pi,
                scaleX = 1,
                scaleY = 1,
            },
            {
                _time = 0.3,
                scaleX = 0.9,
                scaleY = 0.975,
            },
            {
                _time = 0.6,
                scaleX = 1.05,
                scaleY = 1.015,
            },
            {
                _time = 1,
                scaleX = 1,
                scaleY = 1,
            },
        },
    },

    run = {
        speed = 3,
        loop = true,
        loopPoint = 1,
        keyFrames = {
            {
                _time = 0,
                y = 0,
                angle = 0 * math.pi,
                scaleX = 1,
                scaleY = 1,
            },
            {
                _time = 0.15,
                y = 0.1,
                angle = 0.75 * 0.2 * math.pi,
                scaleX = 0.9,
                scaleY = 1.1,
            },
            {
                _time = 0.25,
                scaleX = 0.85,
                scaleY = 1.15,
            },
            {
                _time = 1,
                y = 0.1,
                angle = 0.75 * 0.15 * math.pi,
                scaleX = 1,
                scaleY = 1,
            },
            {
                _time = 1.5,
                y = 0.05,
                angle = 0.75 * 0.12 * math.pi,
                scaleX = 0.95,
                scaleY = 1.05,
            },
            {
                _time = 2,
                y = 0.1,
                angle = 0.75 * 0.15 * math.pi,
                scaleX = 1,
                scaleY = 1,
            },
        },
    },
}
