class PrepareSearchParams
  def initialize(params, query_key)
    @params = params
    @query_key = query_key
  end

  def call
    return if @params[:q].blank?
    prepare_params
  end

  private

  def prepare_params
    return unless @params[:q][@query_key]
    @params[:q][:combinator] = 'or'
    @params[:q][:groupings] = []
    custom_words = @params[:q].delete(@query_key)
    custom_words.split(/\W+/).each_with_index do |word, index|
      @params[:q][:groupings][index] = { trimmed_query_key => word }
    end
    @params[:q]
  end

  def trimmed_query_key
    @_query_key ||= @query_key.sub(/_any$/, '')
  end

end
