###
 * Servo driver
 * http://cylonjs.com
 *
 * Copyright (c) 2013 The Hybrid Group
 * Licensed under the Apache 2.0 license.
###

'use strict'

require './cylon-gpio'

namespace = require 'node-namespace'

namespace "Cylon.Drivers.GPIO", ->
  class @Servo extends Cylon.Driver
    constructor: (opts = {}) ->
      super
      @pin = @device.pin
      @angleValue = 0
      @angleRange = if opts.extraParams.range? then opts.extraParams.range? else { min: 30, max: 150}

    commands: ->
      ['angle', 'currentAngle', 'unlockAngleSafety']

    currentAngle: ->
      @angleValue

    angle: (value) ->
      value = @angleSafety(value) if @safetyLock
      @connection.servoWrite(@pin, value)
      @angleValue = value

    angleSafety: (value) ->
      if value < @angleRange.min or value > @angleRange.max
        if value < @angleRange.min
          value = @angleRange.min
        else
          value = @angleRange.max

      value
