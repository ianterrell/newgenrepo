class V1::Order
  include Mongoid::Document
  
  store_in :'Order'
  
  

  # Field definitions
  
    field :"_id", as: :id, type: String
  
    field :"num", type: Integer
  
    field :"user_id", type: String
  
    field :"shipping_address", type: String
  
    field :"amount", type: Integer
  
    field :"paid", type: Boolean
    

  # Simple validations
  

  # Authorization for mass-assignment
  attr_accessible nil, as: :"Authenticated Without Role Default on create"
  attr_accessible nil, as: :"Authenticated Without Role Default on update"
  attr_accessible :id, :num, :user_id, :shipping_address, :amount, :paid, as: :"admin on create"
  attr_accessible :id, :num, :user_id, :shipping_address, :amount, :paid, as: :"admin on update"


  # Send out properly named attributes for json/xml
  def serializable_hash(options={})
    options[:only]    = [:num, :user_id, :shipping_address, :amount, :paid]
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

def current_user_orders(attributes={}, user_attributes={})
scope = self.all
scope = scope.where('user_id' => user_attributes.with_indifferent_access[:_id])
scope
end
  end


  

  include Custom::Order
end