# coding: utf-8
require './lib/motor'
require './lib/config'

intent "LaunchRequest" do
   ask(Config::LAUNCH_MESSAGE)
end

intent "MotorOnIntent" do
  if Motor.running?
    tell(Config::MOTOR_ALREADY_RUNNING)
  else
    Motor.on(true)
    case Motor.state
    when 'running'
      tell(Config::MOTOR_STARTING)
    when 'error'
      tell(Config::ERROR_MESSAGE)
    end
  end
end

intent "MotorOffIntent" do
  if Motor.running?
    Motor.on(false)
    case Motor.state
    when 'stopped'
      tell(Config::MOTOR_STOPPING)
    when 'error'
      tell(Config::ERROR_MESSAGE)
    end
  else
    tell(Config::MOTOR_ALREADY_STOPPED)
  end
end

intent "MotorStatusIntent" do
  if Motor.running?
    ask(Config::MOTOR_BUSY, session_attributes: { persist: "running" })
  else
    ask(Config::MOTOR_FREE, session_attributes: { persist: "not_running" })
  end
end

intent "YesIntent" do
  persisted_data = request.session_attribute("persist")
  if persisted_data == "running"
    Motor.on(false)
    case Motor.state
    when 'stopped'
      tell(Config::MOTOR_STOPPING)
    when 'error'
      tell(Config::ERROR_MESSAGE)
    end
  else
    Motor.on(true)
    case Motor.state
    when 'running'
      tell(Config::MOTOR_STARTING)
    when 'error'
      tell(Config::ERROR_MESSAGE)
    end
  end
end

intent "NoIntent" do
  tell(Config::DO_NOTHING)
end

intent "SessionEndedRequest" do
  respond("Hmm. something went wrong. Please check the connection and try again later")
end

intent "turn_on_led" do
  respond("enjoy your fucking light")
end

