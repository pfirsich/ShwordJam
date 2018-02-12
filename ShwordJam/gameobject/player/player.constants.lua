return {
    player = {
        width = 0.8,
        height = 1,

        moveDeadzone = 0.25,

        groundProbeWidthFactor = 0.9,
        groundProbeHeight = 0.01,
        groundProbeOffsetY = 0.01,

        maxMoveSpeed = 10.0, -- units/sec
        runStartFactor = 0.5,
        acceleration = 36.0,
        friction = 60.0, -- units/sec/sec
        maxFallSpeed = 12.0,
        gravity = 24.0,
        fastFallThresh = 0.85,
        fastFallFactor = 1.7,

        dashSpeedFactor = 1.2,
        dashInputDelay = 3/60.0,
        dashThresh = 0.9,
        dashMinDuration = 0.1,
        dashDuration = 20/60.0,

        jumpSquatFrictionFactor = 2.0,
        jumpSquatDuration = 5/60.0,

        jumpStartSpeed = 14.0,
        shorthopFactor = 0.67,
        jumpMaxMoveSpeedFactor = 1.0,
        groundToJumpMoveSpeedFactor = 0.8,
        jumpMoveSpeedFactor = 0.5,

        airAcceleration = 15.0,
        airAccelerationMin = 5.0,
        airMaxMoveSpeedFactor = 0.7,
        airFriction = 5.0,

        runEndFactor = 0.1,
    }
}
