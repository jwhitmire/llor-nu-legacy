module DeedsHelper

  def reorder_table(fieldname)
    link_to fieldname.capitalize,  building_list_url( 
      (params[:order] and params[:order] == fieldname) ? {} : { :order => fieldname } 
    )
  end
end
