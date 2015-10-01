class PublicHealth < Contribution
  self.attributes += [:degree]
  self.ignore_attributes += [:degree, :description]
  attr_accessor :degree
  validates :degree, presence: true

  protected

  def copy_attributes
    super
    @tufts_pdf.description = ["Submitted in partial fulfillment of the degree #{long_degree} at the Fletcher School of Law and Diplomacy. Abstract: #{description}"]
    @tufts_pdf.subject = [degree]
    @tufts_pdf.creatordept = creatordept
  end

  private
  def creatordept
    'UA157.005'
  end

  def long_degree
    Qa::Authorities::Local.subauthority_for('public_health_degrees'.freeze).find(degree)['term'.freeze]
  end

  def parent_collection
    'tufts:UA069.001.DO.UA157'
  end
end
