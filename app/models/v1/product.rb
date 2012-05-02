class V1::Product
  include Mongoid::Document
  
  store_in :'product'
  
  

  # Field definitions
  
    field :"_id", as: :id, type: String
  
    field :"name", type: String
  
    field :"description", type: String
  
    field :"price", type: Integer
  
    field :"markdown", type: Float
  
    field :"category_name", type: String
    

  # Simple validations
  

  # Authorization for mass-assignment
  attr_accessible nil, as: :"Unauthenticated Default on create"
  attr_accessible nil, as: :"Unauthenticated Default on update"
  attr_accessible nil, as: :"Authenticated Without Role Default on create"
  attr_accessible nil, as: :"Authenticated Without Role Default on update"
  attr_accessible :id, :name, :description, :price, :markdown, :category_name, as: :"admin on create"
  attr_accessible :id, :name, :description, :price, :markdown, :category_name, as: :"admin on update"


  # Send out properly named attributes for json/xml
  def serializable_hash(options={})
    options[:only]    = [:name, :description, :price, :markdown, :category_name]
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

def sale(attributes={}, user_attributes={})
scope = self.all
scope = scope.where('markdown' => 0.1)
scope
end

def products_by_category(attributes={}, user_attributes={})
scope = self.all
scope = scope.where('category_name' => attributes.with_indifferent_access[:name])
scope
end
  end


  

  include Custom::Product
end