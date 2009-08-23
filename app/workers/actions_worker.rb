class ActionsWorker < Workling::Base
  def process
    loop do
      Action.process_active
      sleep 3
    end
  end
end
