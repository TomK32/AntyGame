class Queen < Ant

  before_validation_on_create :generate

  SKILLS[:fertility] = "T.G. TC.. .A.. .... .... A..A .A.. .CT."
  SKILLS_BASE[:fertility] = 20
  
  def generate
    self.dna = rand(2**63)
  end
end