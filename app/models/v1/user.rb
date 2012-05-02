class V1::User
  include Mongoid::Document
  
  store_in :'user'
  
    # BCrypt password
  include ActiveModel::SecurePassword
  has_secure_password


  # Field definitions
  
    field :"username", type: String
  
    field :"role", type: String
  
    field :"password_digest", type: String
  
    field :"_id", as: :id, type: String
    

  # Simple validations
  

  # Authorization for mass-assignment
  attr_accessible nil, as: :"Unauthenticated Default on create"
  attr_accessible nil, as: :"Unauthenticated Default on update"
  attr_accessible :username, :role, :password_digest, :id, :password, :password_confirmation, as: :"admin on create"
  attr_accessible :username, :role, :password_digest, :id, :password, :password_confirmation, as: :"admin on update"


  # Send out properly named attributes for json/xml
  def serializable_hash(options={})
    options[:only]    = [:username, :role, :password_digest]
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


  
    # Finder from omniauth
    def self.from_omniauth(auth)
      
        if auth["provider"] == "password"
          return where(:password_digest => auth["uid"]).first
        end
      
      raise 'not yet implemented'
    end

    def self.role(user)
  
    role = user.send(:"role")
    role.blank? ? "Authenticated Without Role Default" : role
  
end
  

  include Custom::User
end