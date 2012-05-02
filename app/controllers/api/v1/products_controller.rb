class Api::V1::ProductsController < ApplicationController
  respond_to :json
  
  # GET /products.json
  def index
    scope = params[:scope] || 'all'
    reject_as_unauthorized and return unless authorized_for_scope?(scope)
    @products = scope_named(scope)
    respond_with @products
  end

  # GET /products/1.json
  def show
    reject_as_unauthorized and return unless can_read?
    @product = scope_for_read_finder.find(params[:id])
    respond_with @product
  end

  # GET /products/new.json
  def new
    @product = V1::Product.new
    respond_with @product
  end

  # POST /products.json
  def create
    reject_as_unauthorized and return unless can_create?
    @product = scope_for_create_finder.new(params[:product], as: :"#{current_user_role} on create")
    @product.save
    respond_with @product
  end

  # PUT /products/1.json
  def update
    reject_as_unauthorized and return unless can_update?
    @product = scope_for_update_finder.find(params[:id])
    @product.update_attributes(params[:product], as: :"#{current_user_role} on update")
    respond_with @product
  end

  # DELETE /products/1.json
  def destroy
    reject_as_unauthorized and return unless can_delete?
    @product = scope_for_delete_finder.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
  
protected
  def scope_named(name)
    scope = 'all' unless V1::Product.respond_to?(name)
    if name == 'all'
      V1::Product.all
    else
      V1::Product.send(name, (params[:query] || {}), (current_user ? current_user.attributes : {}))
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
            
              V1::Product
            
        
          when "Authenticated Without Role Default"
            
              V1::Product
            
        
          when "admin"
            
              V1::Product
            
        
      else
        V1::Product
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
            
              V1::Product
            
        
          when "Authenticated Without Role Default"
            
              V1::Product
            
        
          when "admin"
            
              V1::Product
            
        
      else
        V1::Product
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
            
              V1::Product
            
        
          when "Authenticated Without Role Default"
            
              V1::Product
            
        
          when "admin"
            
              V1::Product
            
        
      else
        V1::Product
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
            
              V1::Product
            
        
          when "Authenticated Without Role Default"
            
              V1::Product
            
        
          when "admin"
            
              V1::Product
            
        
      else
        V1::Product
      end
    end
  

  def authorized_for_scope?(scope_name)
    case current_user_role
    
      when "Unauthenticated Default"
        ["all", "exact_match", "sale", "products_by_category"].include?(scope_name)
    
      when "Authenticated Without Role Default"
        ["all", "exact_match", "sale", "products_by_category"].include?(scope_name)
    
      when "admin"
        ["all", "exact_match", "sale", "products_by_category"].include?(scope_name)
    
    else
      false
    end
  end
  
  def authorized_to_read_field?(field_name)
    case current_user_role
    
      when "Unauthenticated Default"
        ["id", "name", "description", "price", "markdown", "category_name"].include?(field_name.to_s)
    
      when "Authenticated Without Role Default"
        ["id", "name", "description", "price", "markdown", "category_name"].include?(field_name.to_s)
    
      when "admin"
        ["id", "name", "description", "price", "markdown", "category_name"].include?(field_name.to_s)
    
    else
      false
    end
  end
  
  include Api::Custom::ProductsController
end
