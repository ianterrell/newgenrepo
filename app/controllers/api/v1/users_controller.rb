class Api::V1::UsersController < ApplicationController
  respond_to :json
  
  # GET /users.json
  def index
    scope = params[:scope] || 'all'
    reject_as_unauthorized and return unless authorized_for_scope?(scope)
    @users = scope_named(scope)
    respond_with @users
  end

  # GET /users/1.json
  def show
    reject_as_unauthorized and return unless can_read?
    @user = scope_for_read_finder.find(params[:id])
    respond_with @user
  end

  # GET /users/new.json
  def new
    @user = V1::User.new
    respond_with @user
  end

  # POST /users.json
  def create
    reject_as_unauthorized and return unless can_create?
    @user = scope_for_create_finder.new(params[:user], as: :"#{current_user_role} on create")
    @user.save
    respond_with @user
  end

  # PUT /users/1.json
  def update
    reject_as_unauthorized and return unless can_update?
    @user = scope_for_update_finder.find(params[:id])
    @user.update_attributes(params[:user], as: :"#{current_user_role} on update")
    respond_with @user
  end

  # DELETE /users/1.json
  def destroy
    reject_as_unauthorized and return unless can_delete?
    @user = scope_for_delete_finder.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
  
protected
  def scope_named(name)
    scope = 'all' unless V1::User.respond_to?(name)
    if name == 'all'
      V1::User.all
    else
      V1::User.send(name, (params[:query] || {}), (current_user ? current_user.attributes : {}))
    end
  end
  
  # Overriding respond_with to perform field level authorization for reading fields.
  def respond_with(*resources, &block)
    replacement = nil
    resources.each do |resource|
      if resource.respond_to?(:each)
        replacement = []
        resource.each do |instance| 
          replacement << scrubbed_hash(instance.serializable_hash)
        end
      else
        replacement = scrubbed_hash(resource.serializable_hash)
      end
    end
  
    super(replacement)
  end
  
  def scrubbed_hash(hash)
    hash.keys.clone.each do |key|
      hash.delete(key) unless authorized_to_read_field?(key)
    end
    hash
  end

  
    def can_read?
      case current_user_role
      
        when "Unauthenticated Default"
          true
      
        when "admin"
          true
      
      else
        false
      end
    end

    def scope_for_read_finder
      case current_user_role
      
          when "Unauthenticated Default"
            
              V1::User
            
        
          when "admin"
            
              V1::User
            
        
      else
        V1::User
      end
    end
  
    def can_create?
      case current_user_role
      
        when "Unauthenticated Default"
          false
      
        when "admin"
          true
      
      else
        false
      end
    end

    def scope_for_create_finder
      case current_user_role
      
          when "Unauthenticated Default"
            
              V1::User
            
        
          when "admin"
            
              V1::User
            
        
      else
        V1::User
      end
    end
  
    def can_update?
      case current_user_role
      
        when "Unauthenticated Default"
          false
      
        when "admin"
          true
      
      else
        false
      end
    end

    def scope_for_update_finder
      case current_user_role
      
          when "Unauthenticated Default"
            
              V1::User
            
        
          when "admin"
            
              V1::User
            
        
      else
        V1::User
      end
    end
  
    def can_delete?
      case current_user_role
      
        when "Unauthenticated Default"
          false
      
        when "admin"
          true
      
      else
        false
      end
    end

    def scope_for_delete_finder
      case current_user_role
      
          when "Unauthenticated Default"
            
              V1::User
            
        
          when "admin"
            
              V1::User
            
        
      else
        V1::User
      end
    end
  

  def authorized_for_scope?(scope_name)
    case current_user_role
    
      when "Unauthenticated Default"
        ["all", "exact_match"].include?(scope_name)
    
      when "admin"
        ["all", "exact_match"].include?(scope_name)
    
    else
      false
    end
  end
  
  def authorized_to_read_field?(field_name)
    case current_user_role
    
      when "Unauthenticated Default"
        ["username"].include?(field_name.to_s)
    
      when "admin"
        ["username", "role", "password_digest", "id"].include?(field_name.to_s)
    
    else
      false
    end
  end
  
  include Api::Custom::UsersController
end
