return {
    player = {
        width = 0.8,
        height = 1.3,

        moveDeadzone = 0.25,

        groundProbeOffsetY = 0.01,

        maxMoveSpeed = 6.0, -- units/sec
        dashSpeedFactor = 0.9,
        runStartFactor = 0.5,
        acceleration = 6.0,
        friction = 10.0, -- units/sec/sec
        maxFallSpeed = 6.0,
        gravity = 10.0,
        fastFallFactor = 1.5,

        dashInputDelay = 3, -- frames
        dashThresh = 0.85,
        dashDuration = 0.3,

        runEndFactor = 0.1,
    }
}
