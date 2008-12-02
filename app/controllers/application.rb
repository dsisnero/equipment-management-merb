class Application < Merb::Controller
  BEFORE_OPTIONS = [ :only, :exclude ].freeze
 
  def self.cache_for(ttl, options = {})
    filter_options = options.only(*BEFORE_OPTIONS)
    cache_option = options.except(*BEFORE_OPTIONS)
 
    before lambda { |c| c.cache_for(ttl, cache_option) }, filter_options
  end
 
  def cache_for(ttl, options = {})
    options['public'] = true if (options.keys & %w[ private no-cache ]).empty?
    options['max-age'] ||= ttl
 
    headers['Expires'] = (Time.now + ttl).httpdate
    headers['Cache-Control'] = options.map { |k,v| v == true ? k : "#{k}=#{v}" }.join(',')
  end
 
end
