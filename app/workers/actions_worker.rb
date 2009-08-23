class ActionsWorker < Workling::Base
  def cycle(options)
    loop do
      Action.process_active
      sleep 3
    end
  end
end
