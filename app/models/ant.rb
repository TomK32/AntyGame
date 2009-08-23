class Ant < ActiveRecord::Base
  belongs_to :anthill
  attr_accessible false # yes, none

  has_one :item
  AVAILABLE_TYPES = %w(Queen Soldier Worker)

  validates_presence_of :dna

  GENES = %w(A C G T)
  # the more '.' you have in the skills the less variation there will be.
  # You can also say that strength and size collide by colling their 
  SKILLS = {
    :strength => ".AG. GC.. ...A ..GC AC.. GT.. T.TC ....",
    :weight   => "TC.C C..A ..CG TG.C .... GC.A .GG. .AAC",
    :speed    => "T.GC AGT. .AG. ..GT .CA. T... A.GT GTAT",
    :size     => "CG.. .... G..C ..T. ..AC .... ...C ..A."
  }
  SKILLS_MAP = {}
  SKILLS.collect{|skill, map| SKILLS_MAP[skill] = map.split('') }

  def generate
    self.dna = rand(2**63)
  end

  def formatted_dna
    @formatted_dna ||= self.dna.to_s(2).unpack("b2"*32).collect{
                          |gene| GENES[gene.to_i(3)] }.join('').unpack("a4"*8).join(' ')
  end
  
  def skills
    @skills ||= {}
    splitted_dna = formatted_dna.split('')
    SKILLS_MAP.each do |skill, map|
      @skills[skill] = 0
      map.each_with_index do |value,key|
        next if value == '.' or value == ' '
        @skills[skill] += 1 if splitted_dna[key] == value
        @skills[skill] -= 1 if splitted_dna[key] == GENES[(GENES.index(value) + 2) % 4]
      end
    end
    @skills
  end
end
