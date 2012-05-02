class Api::V1::DogsController < ApplicationController
  respond_to :json
  
  # GET /dogs.json
  def index
    scope = params[:scope] || 'all'
    reject_as_unauthorized and return unless authorized_for_scope?(scope)
    @dogs = scope_named(scope)
    respond_with @dogs
  end

  # GET /dogs/1.json
  def show
    reject_as_unauthorized and return unless can_read?
    @dog = scope_for_read_finder.find(params[:id])
    respond_with @dog
  end

  # GET /dogs/new.json
  def new
    @dog = V1::Dog.new
    respond_with @dog
  end

  # POST /dogs.json
  def create
    reject_as_unauthorized and return unless can_create?
    @dog = scope_for_create_finder.new(params[:dog], as: :"#{current_user_role} on create")
    @dog.save
    respond_with @dog
  end

  # PUT /dogs/1.json
  def update
    reject_as_unauthorized and return unless can_update?
    @dog = scope_for_update_finder.find(params[:id])
    @dog.update_attributes(params[:dog], as: :"#{current_user_role} on update")
    respond_with @dog
  end

  # DELETE /dogs/1.json
  def destroy
    reject_as_unauthorized and return unless can_delete?
    @dog = scope_for_delete_finder.find(params[:id])
    @dog.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
  
protected
  def scope_named(name)
    scope = 'all' unless V1::Dog.respond_to?(name)
    if name == 'all'
      V1::Dog.all
    else
      V1::Dog.send(name, (params[:query] || {}), (current_user ? current_user.attributes : {}))
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
      
        when "Authenticated Without Role Default"
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
            
              V1::Dog
            
        
          when "Authenticated Without Role Default"
            
              V1::Dog
            
        
          when "admin"
            
              V1::Dog
            
        
      else
        V1::Dog
      end
    end
  
    def can_create?
      case current_user_role
      
        when "Unauthenticated Default"
          false
      
        when "Authenticated Without Role Default"
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
            
              V1::Dog
            
        
          when "Authenticated Without Role Default"
            
              V1::Dog
            
        
          when "admin"
            
              V1::Dog
            
        
      else
        V1::Dog
      end
    end
  
    def can_update?
      case current_user_role
      
        when "Unauthenticated Default"
          false
      
        when "Authenticated Without Role Default"
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
            
              V1::Dog
            
        
          when "Authenticated Without Role Default"
            
              V1::Dog
            
        
          when "admin"
            
              V1::Dog
            
        
      else
        V1::Dog
      end
    end
  
    def can_delete?
      case current_user_role
      
        when "Unauthenticated Default"
          false
      
        when "Authenticated Without Role Default"
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
            
              V1::Dog
            
        
          when "Authenticated Without Role Default"
            
              V1::Dog
            
        
          when "admin"
            
              V1::Dog
            
        
      else
        V1::Dog
      end
    end
  

  def authorized_for_scope?(scope_name)
    case current_user_role
    
      when "Unauthenticated Default"
        ["all", "exact_match"].include?(scope_name)
    
      when "Authenticated Without Role Default"
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
        ["id", "name", "image"].include?(field_name.to_s)
    
      when "Authenticated Without Role Default"
        ["id", "name", "image"].include?(field_name.to_s)
    
      when "admin"
        ["id", "name", "image"].include?(field_name.to_s)
    
    else
      false
    end
  end
  
  include Api::Custom::DogsController
end
