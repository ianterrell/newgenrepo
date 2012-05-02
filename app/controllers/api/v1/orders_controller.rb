class Api::V1::OrdersController < ApplicationController
  respond_to :json
  
  # GET /orders.json
  def index
    scope = params[:scope] || 'all'
    reject_as_unauthorized and return unless authorized_for_scope?(scope)
    @orders = scope_named(scope)
    respond_with @orders
  end

  # GET /orders/1.json
  def show
    reject_as_unauthorized and return unless can_read?
    @order = scope_for_read_finder.find(params[:id])
    respond_with @order
  end

  # GET /orders/new.json
  def new
    @order = V1::Order.new
    respond_with @order
  end

  # POST /orders.json
  def create
    reject_as_unauthorized and return unless can_create?
    @order = scope_for_create_finder.new(params[:order], as: :"#{current_user_role} on create")
    @order.save
    respond_with @order
  end

  # PUT /orders/1.json
  def update
    reject_as_unauthorized and return unless can_update?
    @order = scope_for_update_finder.find(params[:id])
    @order.update_attributes(params[:order], as: :"#{current_user_role} on update")
    respond_with @order
  end

  # DELETE /orders/1.json
  def destroy
    reject_as_unauthorized and return unless can_delete?
    @order = scope_for_delete_finder.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
  
protected
  def scope_named(name)
    scope = 'all' unless V1::Order.respond_to?(name)
    if name == 'all'
      V1::Order.all
    else
      V1::Order.send(name, (params[:query] || {}), (current_user ? current_user.attributes : {}))
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
      
          when "Authenticated Without Role Default"
            
              scope_named(current_user_orders)
            
        
          when "admin"
            
              V1::Order
            
        
      else
        V1::Order
      end
    end
  
    def can_create?
      case current_user_role
      
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
      
          when "Authenticated Without Role Default"
            
              V1::Order
            
        
          when "admin"
            
              V1::Order
            
        
      else
        V1::Order
      end
    end
  
    def can_update?
      case current_user_role
      
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
      
          when "Authenticated Without Role Default"
            
              V1::Order
            
        
          when "admin"
            
              V1::Order
            
        
      else
        V1::Order
      end
    end
  
    def can_delete?
      case current_user_role
      
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
      
          when "Authenticated Without Role Default"
            
              V1::Order
            
        
          when "admin"
            
              V1::Order
            
        
      else
        V1::Order
      end
    end
  

  def authorized_for_scope?(scope_name)
    case current_user_role
    
      when "Authenticated Without Role Default"
        ["current_user_orders"].include?(scope_name)
    
      when "admin"
        ["all", "exact_match", "current_user_orders"].include?(scope_name)
    
    else
      false
    end
  end
  
  def authorized_to_read_field?(field_name)
    case current_user_role
    
      when "Authenticated Without Role Default"
        ["id", "num", "user_id", "shipping_address", "amount", "paid"].include?(field_name.to_s)
    
      when "admin"
        ["id", "num", "user_id", "shipping_address", "amount", "paid"].include?(field_name.to_s)
    
    else
      false
    end
  end
  
  include Api::Custom::OrdersController
end
