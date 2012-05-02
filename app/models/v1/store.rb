class V1::Store
  include Mongoid::Document
  
  store_in :'store'
  
  

  # Field definitions
  
    field :"_id", as: :id, type: String
  
    field :"name", type: String
  
    field :"phone", type: String
  
    field :"street", type: String
  
    field :"city", type: String
  
    field :"state", type: String
  
    field :"zip", type: String
  
    field :"latitude", as: :lat, type: Float
  
    field :"longitude", as: :long, type: Float
    

  # Simple validations
  

  # Authorization for mass-assignment
  attr_accessible nil, as: :"Unauthenticated Default on create"
  attr_accessible nil, as: :"Unauthenticated Default on update"
  attr_accessible nil, as: :"Authenticated Without Role Default on create"
  attr_accessible nil, as: :"Authenticated Without Role Default on update"
  attr_accessible :id, :name, :phone, :street, :city, :state, :zip, :lat, :long, as: :"admin on create"
  attr_accessible :id, :name, :phone, :street, :city, :state, :zip, :lat, :long, as: :"admin on update"


  # Send out properly named attributes for json/xml
  def serializable_hash(options={})
    options[:only]    = [:name, :phone, :street, :city, :state, :zip]
    options[:methods] = [:id, :lat, :long]
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


  

  include Custom::Store
end