class Api::V1::IncomingContactsController < ApplicationController
  respond_to :json
  
  # GET /incoming_contacts.json
  def index
    scope = params[:scope] || 'all'
    reject_as_unauthorized and return unless authorized_for_scope?(scope)
    @incoming_contacts = scope_named(scope)
    respond_with @incoming_contacts
  end

  # GET /incoming_contacts/1.json
  def show
    reject_as_unauthorized and return unless can_read?
    @incoming_contact = scope_for_read_finder.find(params[:id])
    respond_with @incoming_contact
  end

  # GET /incoming_contacts/new.json
  def new
    @incoming_contact = V1::IncomingContact.new
    respond_with @incoming_contact
  end

  # POST /incoming_contacts.json
  def create
    reject_as_unauthorized and return unless can_create?
    @incoming_contact = scope_for_create_finder.new(params[:incoming_contact], as: :"#{current_user_role} on create")
    @incoming_contact.save
    respond_with @incoming_contact
  end

  # PUT /incoming_contacts/1.json
  def update
    reject_as_unauthorized and return unless can_update?
    @incoming_contact = scope_for_update_finder.find(params[:id])
    @incoming_contact.update_attributes(params[:incoming_contact], as: :"#{current_user_role} on update")
    respond_with @incoming_contact
  end

  # DELETE /incoming_contacts/1.json
  def destroy
    reject_as_unauthorized and return unless can_delete?
    @incoming_contact = scope_for_delete_finder.find(params[:id])
    @incoming_contact.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
  
protected
  def scope_named(name)
    scope = 'all' unless V1::IncomingContact.respond_to?(name)
    if name == 'all'
      V1::IncomingContact.all
    else
      V1::IncomingContact.send(name, (params[:query] || {}), (current_user ? current_user.attributes : {}))
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
          false
      
        when "Authenticated Without Role Default"
          false
      
        when "admin"
          true
      
      else
        false
      end
    end

    def scope_for_read_finder
      case current_user_role
      
          when "Unauthenticated Default"
            
              V1::IncomingContact
            
        
          when "Authenticated Without Role Default"
            
              V1::IncomingContact
            
        
          when "admin"
            
              V1::IncomingContact
            
        
      else
        V1::IncomingContact
      end
    end
  
    def can_create?
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

    def scope_for_create_finder
      case current_user_role
      
          when "Unauthenticated Default"
            
              V1::IncomingContact
            
        
          when "Authenticated Without Role Default"
            
              V1::IncomingContact
            
        
          when "admin"
            
              V1::IncomingContact
            
        
      else
        V1::IncomingContact
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
            
              V1::IncomingContact
            
        
          when "Authenticated Without Role Default"
            
              V1::IncomingContact
            
        
          when "admin"
            
              V1::IncomingContact
            
        
      else
        V1::IncomingContact
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
            
              V1::IncomingContact
            
        
          when "Authenticated Without Role Default"
            
              V1::IncomingContact
            
        
          when "admin"
            
              V1::IncomingContact
            
        
      else
        V1::IncomingContact
      end
    end
  

  def authorized_for_scope?(scope_name)
    case current_user_role
    
      when "Unauthenticated Default"
        [].include?(scope_name)
    
      when "Authenticated Without Role Default"
        [].include?(scope_name)
    
      when "admin"
        ["all", "exact_match"].include?(scope_name)
    
    else
      false
    end
  end
  
  def authorized_to_read_field?(field_name)
    case current_user_role
    
      when "Unauthenticated Default"
        [].include?(field_name.to_s)
    
      when "Authenticated Without Role Default"
        [].include?(field_name.to_s)
    
      when "admin"
        ["id", "email", "message", "handled"].include?(field_name.to_s)
    
    else
      false
    end
  end
  
  include Api::Custom::IncomingContactsController
end
