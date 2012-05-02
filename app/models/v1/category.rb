class V1::Category
  include Mongoid::Document
  
  store_in :'category'
  
  

  # Field definitions
  
    field :"_id", as: :id, type: String
  
    field :"name", type: String
    

  # Simple validations
  

  # Authorization for mass-assignment
  attr_accessible nil, as: :"Unauthenticated Default on create"
  attr_accessible nil, as: :"Unauthenticated Default on update"
  attr_accessible nil, as: :"Authenticated Without Role Default on create"
  attr_accessible nil, as: :"Authenticated Without Role Default on update"
  attr_accessible :id, :name, as: :"admin on create"
  attr_accessible :id, :name, as: :"admin on update"


  # Send out properly named attributes for json/xml
  def serializable_hash(options={})
    options[:only]    = [:name]
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


  

  include Custom::Category
end