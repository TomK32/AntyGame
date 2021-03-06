class Ant < ActiveRecord::Base
  belongs_to :anthill
  attr_accessible false # yes, none

  has_one :item
  AVAILABLE_TYPES = %w(Queen Soldier Worker)

  validates_presence_of :dna
  before_create :do_evolve
  
  GENES = %w(A C G T)
  # the more '.' you have in the skills the less variation there will be.
  # You can also say that strength and size collide by colling their 
  SKILLS = {
    :strength => ".AG. GC.. ...A ..GC AC.. GT.. T.TC ....",
    :weight   => "TC.C C..A ..CG TG.C .... GC.A .GG. .AAC",
    :speed    => "T.GC AGT. .AG. ..GT .CA. T... A.GT GTAT",
    :size     => "CG.. .... G..C ..T. ..AC .... ...C ..A.",
    :lifetime => "ACG. G..T .ACT ...A .GC. G.T. .C.T .AG.."
  }
  SKILLS_MAP = {}
  SKILLS_BASE = {:lifetime => 100}


  def generate
    @formatted_dna = nil
    self.dna = rand(2**63)
  end

  def formatted_dna
    @formatted_dna ||= self.dna.to_s(4).unpack("b2"*32).collect{
                          |gene| GENES[gene.to_i(2)] }.join('').unpack("a4"*8).join(' ')
  end
  
  def update_skills_map
    SKILLS.collect do |skill, map|
      SKILLS_MAP[skill] ||= map.split('')
      SKILLS_BASE[skill] ||= 5
    end
  end

  def skills
    update_skills_map
    @skills ||= {}
    splitted_dna = formatted_dna.split('')
    SKILLS_MAP.each do |skill, map|
      @skills[skill] = SKILLS_BASE[skill]
      map.each_with_index do |value,key|
        next if value == '.' or value == ' '
        @skills[skill] += 1 if splitted_dna[key] == value
        @skills[skill] -= 1 if splitted_dna[key] == GENES[(GENES.index(value) + 2) % 4]
      end
    end
    @skills
  end
  
  def do_evolve
    tmp = self.dna.to_s(2).split('')
    r = rand(tmp.size)
    tmp[r] = (tmp[r].to_i + 1) % 2
    self.dna = tmp.join('').to_i(2)
  end
end
