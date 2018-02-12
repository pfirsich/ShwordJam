return {
    player = {
        width = 0.8,
        height = 1,

        moveDeadzone = 0.25,

        groundProbeOffsetY = 0.01,

        maxMoveSpeed = 10.0, -- units/sec
        dashSpeedFactor = 1,
        runStartFactor = 0.5,
        acceleration = 36.0,
        friction = 20.0, -- units/sec/sec
        maxFallSpeed = 12.0,
        gravity = 24.0,
        fastFallThresh = 0.85,
        fastFallFactor = 1.7,

        dashInputDelay = 3/60.0, -- frames
        dashThresh = 0.85,
        dashDuration = 0.3,

        jumpSquatFrictionFactor = 2.0,
        jumpSquatDuration = 5/60.0,

        jumpStartSpeed = 12.0,
        shorthopFactor = 0.5,
        jumpMaxMoveSpeedFactor = 1,
        groundToJumpMoveSpeedFactor = 0.8,
        jumpMoveSpeedFactor = 0.5,

        runEndFactor = 0.1,
    }
}
