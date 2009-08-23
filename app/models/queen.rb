class Queen < Ant

  before_validation_on_create :generate
  after_create :generate_workers

  SKILLS[:fertility] = "T.G. TC.. .A.. .... .... A..A .A.. .CT."
  SKILLS_BASE[:fertility] = 20
  
  DEFAULT_WORKERS_COUNT = 10
  
  def generate
    self.dna = rand(2**63)
  end

  # would be boring to not have any workers in a fresh anthill
  def generate_workers
    return if self.anthill.queens.count > 1
    worker = self.anthill.workers.new do |worker|
      worker.dna = self.dna
      worker.count = DEFAULT_WORKERS_COUNT
    end
    worker.save!
  end
end