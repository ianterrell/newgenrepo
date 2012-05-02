class V1::SalesReport
  include Mongoid::Document
  
  store_in :'SalesReport'
  
  

  # Field definitions
  
    field :"_id", as: :id, type: String
  
    field :"month", type: String
  
    field :"quantity", type: Integer
    

  # Simple validations
  

  # Authorization for mass-assignment
  attr_accessible nil, as: :"Unauthenticated Default on create"
  attr_accessible nil, as: :"Unauthenticated Default on update"
  attr_accessible nil, as: :"Authenticated Without Role Default on create"
  attr_accessible nil, as: :"Authenticated Without Role Default on update"
  attr_accessible :id, :month, :quantity, as: :"admin on create"
  attr_accessible :id, :month, :quantity, as: :"admin on update"


  # Send out properly named attributes for json/xml
  def serializable_hash(options={})
    options[:only]    = [:month, :quantity]
    options[:methods] = [:id]
    super options
  end

    # Scopes for data access
  class << self
    def exact_match(attributes={}, user_attributes={})
scope = self.all
                  attributes.each_pair do |name, value|
                    scope = scope.where(name => value)
                  end

scope
end
  end


  

  include Custom::SalesReport
end