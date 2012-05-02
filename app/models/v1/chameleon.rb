class V1::Chameleon
  include DataMapper::Resource
  include DataMapper::MassAssignmentSecurity
  
  storage_names[:'4fa143f1f3f90e119e000185'] = 'chameleons'
  def self.default_repository_name
    :'4fa143f1f3f90e119e000185'
  end
  
  

  # Property definitions
  
    property :id, Serial, field: "id", key: true, required: false
  
    property :name, Text, field: "name", key: false, required: false
  
    property :color, Text, field: "color", key: false, required: false
    

  # Authorization for mass-assignment
  attr_accessible nil, as: :"Unauthenticated Default on create"
  attr_accessible nil, as: :"Unauthenticated Default on update"
  attr_accessible nil, as: :"Authenticated Without Role Default on create"
  attr_accessible nil, as: :"Authenticated Without Role Default on update"
  attr_accessible :id, :name, :color, as: :"admin on create"
  attr_accessible :id, :name, :color, as: :"admin on update"

  
  def serializable_hash(options={})
    self.to_json(options.merge(to_json: false))
  end

    # Scopes for data access
  class << self
    def exact_match(attributes={}, user_attributes={})
scope = self.all
                  attributes.each_pair do |name, value|
                    scope = scope.all(name => value)
                  end

scope
end
  end


  
  
  include Custom::Chameleon
end