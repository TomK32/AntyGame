class Queen < Ant

  before_validation_on_create :generate
  
  def generate
    self.dna = rand(2**63)
  end
end