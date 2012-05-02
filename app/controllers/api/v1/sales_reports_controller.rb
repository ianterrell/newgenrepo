class Api::V1::SalesReportsController < ApplicationController
  respond_to :json
  
  # GET /sales_reports.json
  def index
    scope = params[:scope] || 'all'
    reject_as_unauthorized and return unless authorized_for_scope?(scope)
    @sales_reports = scope_named(scope)
    respond_with @sales_reports
  end

  # GET /sales_reports/1.json
  def show
    reject_as_unauthorized and return unless can_read?
    @sales_report = scope_for_read_finder.find(params[:id])
    respond_with @sales_report
  end

  # GET /sales_reports/new.json
  def new
    @sales_report = V1::SalesReport.new
    respond_with @sales_report
  end

  # POST /sales_reports.json
  def create
    reject_as_unauthorized and return unless can_create?
    @sales_report = scope_for_create_finder.new(params[:sales_report], as: :"#{current_user_role} on create")
    @sales_report.save
    respond_with @sales_report
  end

  # PUT /sales_reports/1.json
  def update
    reject_as_unauthorized and return unless can_update?
    @sales_report = scope_for_update_finder.find(params[:id])
    @sales_report.update_attributes(params[:sales_report], as: :"#{current_user_role} on update")
    respond_with @sales_report
  end

  # DELETE /sales_reports/1.json
  def destroy
    reject_as_unauthorized and return unless can_delete?
    @sales_report = scope_for_delete_finder.find(params[:id])
    @sales_report.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
  
protected
  def scope_named(name)
    scope = 'all' unless V1::SalesReport.respond_to?(name)
    if name == 'all'
      V1::SalesReport.all
    else
      V1::SalesReport.send(name, (params[:query] || {}), (current_user ? current_user.attributes : {}))
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
            
              V1::SalesReport
            
        
          when "Authenticated Without Role Default"
            
              V1::SalesReport
            
        
          when "admin"
            
              V1::SalesReport
            
        
      else
        V1::SalesReport
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
            
              V1::SalesReport
            
        
          when "Authenticated Without Role Default"
            
              V1::SalesReport
            
        
          when "admin"
            
              V1::SalesReport
            
        
      else
        V1::SalesReport
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
            
              V1::SalesReport
            
        
          when "Authenticated Without Role Default"
            
              V1::SalesReport
            
        
          when "admin"
            
              V1::SalesReport
            
        
      else
        V1::SalesReport
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
            
              V1::SalesReport
            
        
          when "Authenticated Without Role Default"
            
              V1::SalesReport
            
        
          when "admin"
            
              V1::SalesReport
            
        
      else
        V1::SalesReport
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
        ["id", "month", "quantity"].include?(field_name.to_s)
    
      when "Authenticated Without Role Default"
        ["id", "month", "quantity"].include?(field_name.to_s)
    
      when "admin"
        ["id", "month", "quantity"].include?(field_name.to_s)
    
    else
      false
    end
  end
  
  include Api::Custom::SalesReportsController
end
